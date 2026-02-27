# Feature Structure — Bikalk

Every feature under `lib/features/` follows the same folder layout. This document defines what belongs where so files don't end up in the wrong place.

```
<feature>/
  application/
  data/
    models/
    repositories/
    sources/
  domain/
    entities/
    repositories/
  presentation/
    pages/
    widgets/
```

---

## `application/`

Holds the Cubit or BLoC for this feature — the state management brain.

**What goes here:**
- `*_cubit.dart` / `*_bloc.dart` — the class that holds state and calls the repository
- `*_state.dart` — all possible states, extend `Equatable`
- `*_event.dart` — events, for BLoC only (Cubit doesn't need them)

**Why it exists:** Something has to sit between the UI and the data layer, decide what to do with results, and tell the UI what to render. That's this layer. It's the only place that's allowed to call repositories.

**Rules:**
- No Firebase imports
- No Flutter widget imports
- Does not know how data is stored or fetched — only calls the domain interface

---

## `presentation/`

Pure Flutter UI. Nothing here knows Firebase exists.

### `presentation/pages/`

Full screens — the things `go_router` navigates to.

**What goes here:** one file per screen (e.g. `sign_in_page.dart`, `price_breakdown_page.dart`). A page sets up its Cubit/BLoC via `BlocProvider`, uses `BlocBuilder` to render state, and uses `BlocListener` for side effects like navigation or snackbars.

**What doesn't go here:** raw Firebase calls, business logic, data formatting.

### `presentation/widgets/`

Smaller UI components used inside this feature's pages.

**What goes here:** forms, cards, toggles, list items specific to this feature (e.g. `bike_mode_toggle.dart`, `fare_result_card.dart`).

**What doesn't go here:** anything used by more than one feature — that belongs in `lib/core/widgets/`.

---

## `domain/`

Plain Dart only. No Flutter, no Firebase, no packages. This is the most stable layer — it rarely changes.

### `domain/entities/`

The core data objects of the feature, modelled as plain Dart classes.

**What goes here:** classes with just properties that represent a real concept (e.g. `User`, `FareCalculation`, `Report`). No serialisation methods, no `fromJson`, no Firestore — those belong in `data/models/`.

### `domain/repositories/`

Abstract interfaces that define what data operations this feature needs.

**What goes here:** `abstract class IAuthRepository { Future<...> signIn(...); }`. The application layer depends on these; the data layer implements them.

**Why it exists:** it's the seam that lets the BLoC be tested without Firebase. You swap the real implementation for a fake one in tests without changing a single line of BLoC code.

---

## `data/`

The only layer that knows Firebase (or any other SDK) exists.

### `data/sources/`

Each file talks directly to one external system.

**What goes here:** `firebase_auth_source.dart`, `firestore_user_source.dart`, `preferences_local_source.dart`. Methods here take and return raw Firebase/SDK types. A source for Firebase Auth calls `FirebaseAuth.instance`, a source for SharedPreferences calls `SharedPreferences.getInstance()`, etc.

**Why "sources" and not "datasources" or "persistence"?** The folder is already inside `data/`, so calling it `datasources` creates the redundant path `data/datasources/`. "Persistence" implies data is only saved locally — sources cover both remote (Firebase) and local (SharedPreferences) access. `source` is the shortest name that covers both.

### `data/repositories/`

Concrete implementations of the domain interfaces.

**What goes here:** `auth_repository.dart` which `implements IAuthRepository`. It calls sources, wraps SDK exceptions into `Failure` objects from `lib/core/errors/`, and maps models to entities. This is the only place `try/catch` around Firebase calls should appear.

### `data/models/`

The data-format bridge — knows how to convert an object between all the forms it needs to be in.

**What goes here:** `UserModel`, `FareEstimationModel`, etc. Each model has:

- `UserModel.fromFirestore(DocumentSnapshot)` — parses a raw Firestore document
- `UserModel.toFirestore()` — returns a `Map<String, dynamic>` for writing to Firestore
- `UserModel.toEntity()` — strips Firebase concerns, returns the plain `UserEntity`

This way:
- The BLoC only ever works with clean `Entity` objects
- Firestore only ever receives plain maps
- The conversion logic is in one place, not scattered across sources and blocs

