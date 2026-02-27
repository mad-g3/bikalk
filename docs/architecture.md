# Architecture — Bikalk

Bikalk uses a **layered, feature-first architecture**. Each feature (`auth`, `fare_estimation`,
`reporting`, etc.) is a self-contained directory under `lib/features/` that follows the same
four-layer folder pattern. This makes it easy to find things, swap out implementations, and test
each layer in isolation.

## The four layers

```
┌──────────────────────────────┐
│   presentation/              │  Flutter widgets & pages — renders state, dispatches events
│   pages/ · widgets/          │
├──────────────────────────────┤
│   application/               │  Cubit / BLoC — holds state, calls repositories
│   *_cubit.dart · *_bloc.dart │
├──────────────────────────────┤
│   domain/                    │  Plain Dart — entities + repository interfaces (no Flutter, no Firebase)
│   entities/ · repositories/  │
├──────────────────────────────┤
│   data/                      │  Firebase / storage — implements interfaces, maps data formats
│   models/ · repositories/    │
│   sources/                   │
└──────────────────────────────┘
          │
          │  (sits outside features — wires everything together)
          ▼
┌──────────────────────────────┐
│   lib/app/                   │  DI (get_it) · Router (go_router) · Theme
└──────────────────────────────┘
```

### Dependency rule

Each layer only knows about the layer **directly below** it:

- `presentation` → depends on `application`
- `application` → depends on `domain`
- `data` → depends on `domain` (it *implements* the domain interfaces)
- `domain` → depends on nothing (pure Dart)

`lib/app/` is the only place that knows about all layers — it wires them together at startup.

---

## Presentation layer — `<feature>/presentation/`

Pure Flutter UI. No Firebase, no business logic.

- **`pages/`** — full screens navigated to via `go_router`. Each page creates (or receives) a
  Cubit/BLoC and calls `BlocBuilder`/`BlocListener` to render state.
- **`widgets/`** — smaller UI pieces used inside pages (forms, cards, toggles). If a widget is
  shared across features, it belongs in `lib/core/widgets/` instead.

The page's job is: dispatch an event → listen to state → show the right UI.

---

## Application layer — `<feature>/application/`

State management. One Cubit (or BLoC for more complex event flows) per feature concern.

| File                           | What goes here                                                                   |
|--------------------------------|----------------------------------------------------------------------------------|
| `*_cubit.dart` / `*_bloc.dart` | The class itself — imports the repository interface, calls methods, emits states |
| `*_state.dart`                 | Immutable state classes — `extends Equatable`                                    |
| `*_event.dart`                 | Events (BLoC only)                                                               |

Rules:

- Never import `firebase_*` packages here.
- Never import Flutter widgets here.
- Convert repository `Failure` objects into UI-friendly state fields (e.g.
  `errorMessage: failure.message`).

---

## Domain layer — `<feature>/domain/`

The stable contract layer. Plain Dart — no Flutter, no Firebase, no packages at all.

- **`entities/`** — bare data classes that represent a real concept in the app (e.g. `User`,
  `FareCalculation`, `Report`). Just properties. No `fromJson`, no Firestore — those conversions
  belong in `data/models/`.
- **`repositories/`** — abstract interfaces (`abstract class IAuthRepository { ... }`). The
  application layer depends on these; the data layer implements them. This is the seam that lets you
  swap Firebase for a mock in tests without touching a single BLoC.

---

## Data layer — `<feature>/data/`

The only layer that knows Firebase exists.

- **`sources/`** — each file talks to one external system (Firebase Auth, Firestore,
  SharedPreferences, a map API). A source's methods take and return raw Firebase/SDK types.
- **`repositories/`** — one concrete class per domain interface (e.g.
  `AuthRepository implements IAuthRepository`). It calls sources, converts SDK exceptions into
  `Failure` objects from `lib/core/errors/failures.dart`, and maps raw data via models. The BLoC
  never sees a `FirebaseException`.
- **`models/`** — the data-format bridge. A model (e.g. `UserModel`) knows how to convert between
  all three formats an object can be in:
    - **`fromFirestore(DocumentSnapshot)`** — parses a Firestore document snapshot
    - **`fromEntity(Entity)`** — converts a clean domain entity into a model for
      writing to Firestore
    - **`fromMap(Map<String, dynamic>)`** — parses a raw map (e.g. from Firestore or JSON)
    - **`toMap()`** — serialises to a `Map<String, dynamic>` for writing to Firestore or using the
      Map directly
    - **`toEntity()`** — strips all Firebase/serialisation concerns and returns the plain domain
      `Entity`

  This means the BLoC only ever works with clean entities, and Firestore only ever sees plain maps.

---

## App wiring — `lib/app/`

Not a feature — the bootstrap layer.

| File          | Purpose                                                      |
|---------------|--------------------------------------------------------------|
| `app.dart`    | Root `MaterialApp.router`, theme, router config              |
| `di.dart`     | Registers all sources, repositories, and cubits into `GetIt` |
| `router.dart` | `GoRouter` instance — routes, redirects, auth guard          |
| `routes.dart` | `AppRoutes` constants (path strings)                         |
| `theme/`      | `ThemeData`, `AppColors`, `AppTextStyles`                    |

**Why GetIt?** Without a DI container, a widget deep in the UI tree that needs a repository would
require passing that dependency through the constructor of every single widget in the chain above
it. GetIt acts as a global service locator — register once in `di.dart`, resolve anywhere with
`sl<IAuthRepository>()`. This keeps constructors clean and avoids mixing dependency management into
widget trees.

---

## How it flows in practice

**Example — user signs in:**

```
SignInPage (presentation)
  └─ dispatches SignInRequested event
       │
AuthBloc (application)
  └─ calls IAuthRepository.signIn(email, password)
       │
AuthRepository (data/repositories)
  └─ calls FirebaseAuthSource.signIn(email, password)
       └─ on FirebaseAuthException → returns Left(AuthFailure(...))
       └─ on success → maps UserModel.toEntity() → returns Right(UserEntity)
       │
AuthBloc receives Either<Failure, UserEntity>
  └─ Left  → emits AuthFailure state → page shows AppSnackbars.error(...)
  └─ Right → emits AuthAuthenticated state → router redirects to /home
```

**Where errors are converted:**

| Layer        | What happens                                                    |
|--------------|-----------------------------------------------------------------|
| `source`     | throws raw `FirebaseAuthException` / `Exception`                |
| `repository` | catches it, returns `Left(AuthFailure('Incorrect password.'))`  |
| `cubit/bloc` | maps `Left` to an error state with `failure.message`            |
| `page`       | reads state, calls `AppSnackbars.error(context, state.message)` |

The UI never knows Firebase exists.

