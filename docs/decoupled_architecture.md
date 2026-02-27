# Decoupled Architecture — Bikalk (Simple, Team-Friendly)

This document adapts the decoupled architecture to Bikalk’s features while keeping it lightweight and easy for a 5-person team to contribute. The goal: clear separation, minimal ceremony.

## Layers and responsibilities

### 1) Presentation layer (Flutter UI only)
- Contains pages and widgets.
- No SDK calls. No business logic.
- Talks only to Cubit/BLoC and renders state.

### 2) Application layer (Cubit/BLoC)
- Holds state and orchestrates use cases.
- Calls repositories.
- Converts errors into UI-friendly states.

### 3) Domain layer (entities + interfaces)
- Small, stable contracts and core entities.
- Keeps BLoC/Cubit independent from Firebase or plugins.

### 4) Data layer (repositories + sources)
- Implements domain interfaces.
- Sources talk to Firebase, maps, and local storage.
- Maps SDK models into domain models.

### 5) App wiring (DI + Router)
- DI sets up sources, repositories, and Cubits.
- Router defines navigation and route guards (auth).

---

## Feature slices (Bikalk)
Each feature has the same folder pattern to make it easy to find things.

- `features/auth` — sign-in, sign-up, email verification
- `features/fare_estimation` — vehicle choice, route input, price breakdown
- `features/reporting` — report a problem CRUD
- `features/preferences` — theme/language/default bike mode
- `features/map` — map view and external navigation

---

## Example flows (short and practical)

### A) Fare estimation
1. `route_input_page.dart` collects origin + destination via map and calculates distance.
2. `vehicle_selection_page.dart` lets user pick Electric or Petrol.
3. User triggers estimation; `FareEstimationCubit` calls `IFareEstimationRepository.estimateFare(distanceKm, bikeMode)`.
4. Repository:
   - Fetches matching `fare_rates` from `FareRatesFirestoreSource` (based on distance range and bike mode).
   - Calculates `suggestedMin` and `suggestedMax` using the rate's `baseFare`, `energyRate`, and distance.
   - Saves the estimation record to `fare_estimations/{id}` via `FareEstimationsFirestoreSource`.
5. Cubit emits `FareEstimationLoaded` with the suggested fare range.
6. `price_breakdown_page.dart` displays results, energy cost breakdown, and the efficiency delta (Electric vs Petrol).

### B) Report a Problem (CRUD)
1. `report_edit_page.dart` submits a report.
2. `ReportsCubit` calls `IReportsRepository`.
3. Repository writes to `reports/{id}` via Firestore source.
4. `report_list_page.dart` listens to Cubit state for updated list.

### C) Auth
1. UI dispatches `SignInRequested` or `SignUpRequested`.
2. `AuthBloc` calls `IAuthRepository`.
3. Data layer uses Firebase Auth and creates/updates `users/{uid}`.
4. Router reacts to auth state and redirects.

---

## File map (examples)
- Presentation: `lib/features/fare_estimation/presentation/pages/price_breakdown_page.dart`
- Application: `lib/features/fare_estimation/application/fare_estimation_cubit.dart`
- Domain: `lib/features/fare_estimation/domain/repositories/i_fare_estimation_repository.dart`
- Data: `lib/features/fare_estimation/data/sources/fare_rates_firestore_source.dart` (read rates), `fare_estimations_firestore_source.dart` (save user estimates)
- Wiring: `lib/app/di.dart`, `lib/app/router.dart`

---

## Rules of thumb (keep it simple)
- UI never calls Firebase or plugins directly.
- Cubit/BLoC never imports Firebase SDKs.
- Repositories are the only bridge between app logic and SDKs.
- If a file feels too abstract, keep it in the feature and skip extra layers.

---

## ASCII diagram

```
Presentation (UI)
  pages/widgets
        |
        v
Application (Cubit/BLoC)
  state + orchestration
        |
        v
Domain (entities + interfaces)
        |
        v
Data (repositories + sources)
  Firebase / Maps / SharedPreferences

App wiring
  DI + Router
```


