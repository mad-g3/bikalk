# Tools & Technologies — Bikalk (Android, Flutter)

This document lists the primary technologies, plugins, and utilities used to implement the
assignment on Android with Flutter, Firebase, Google Maps, BLoC/Cubit, and `go_router` — trimmed to
only what we’ll actually use.

## Core Stack

- Flutter (stable) + Dart
- Android target only (compile/target SDK as per Flutter template)
- Firebase (already integrated per project notes)

## Firebase Services

- Firebase Authentication
    - Email/Password sign-up and sign-in
    - Email verification
    - Google Sign-In
- Cloud Firestore
    - `users/{uid}` for user profiles
    - `fare_rates/{id}` for fare rates
    - `reports/{id}` for "Report a Problem" CRUD
- Not used: Firebase App Check, Analytics

## State Management

- `bloc` and `flutter_bloc`
    - Function-based handlers via `on<Event>((event, emit) { ... })`
    - `Cubit` for simple local or screen state (e.g., fare form, preferences)
- `equatable` for value-based equality of states/events

## Navigation

- `go_router` for routing (Navigator 2.0 under the hood)
    - BottomNavigationBar as the main shell
    - Type-safe route names/paths defined centrally in `app/router.dart`

## Maps & Location

- `google_maps_flutter` for embedded map on the breakdown/map screens
- `url_launcher` for external Google Maps turn-by-turn navigation
- Not used: Places API, Geocoding

## Local Storage

- `shared_preferences` for user preferences (theme, language, default bike mode)

## UI & Theming

- Material 3 with custom `ThemeData`

## Dependency Injection

- `get_it` for lightweight service location / DI

## DevX & Linting

- Flutter lints (as configured in `analysis_options.yaml`)

## Serialization

- Hand-written models converters (no code generators)

## Networking/Connectivity

- Not used to check connection in the project

## Testing

- Unit testing and widget testing
- `bloc_test` for BLoC/Cubit testing
- `mocktail` for mocking repositories/sources

## Android-Specific Setup

- Google Maps API key in `AndroidManifest.xml` with meta-data entry
- Intent URIs for turn-by-turn navigation via `url_launcher`

## Build & Release

- APK will be released publicly on github repo
- No Play Store app listing will be made

These tools align with the modular architecture: UI depends on BLoC/Cubit, BLoC/Cubit depends on
repositories, repositories wrap Firebase SDKs. This separation simplifies testing, reduces cognitive
load when working on a feature and eases future expansions hence maintainable.
