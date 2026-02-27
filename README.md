# Bikalk

Bikalk is an Android app that gives motorcycle passengers and riders in Kigali a data-driven fare
estimate before they negotiate. It calculates a suggested fare range using real-time route distance
and current energy costs for both petrol and electric motorcycles, helping reduce the pricing
friction and identity-based fare discrimination that affects daily commuters in the city.

---

## Documentation

| Doc                                                      | What it covers                                                                                 |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------|
| [Architecture](docs/architecture.md)                     | Layered architecture overview, ASCII diagram, dependency rules, how errors flow, why GetIt     |
| [Feature Structure](docs/feature_structure.md)           | What goes in `application/`, `presentation/`, `domain/`, `data/` and each of their sub-folders |
| [Decoupled Architecture](docs/decoupled_architecture.md) | Feature slices, example flows (auth, fare, reporting), rules of thumb                          |
| [Tools & Technologies](docs/tools_and_technologies.md)   | Every package used and why                                                                     |

---

## Project structure (top level)

```
lib/
  app/          # Bootstrap — DI, router, theme
  core/         # Shared utilities, widgets, error types
  features/     # One folder per feature, each with the same 4-layer structure
    auth/
    fare_estimation/
    reporting/
    preferences/
    map/
```

Start with [Feature Structure](docs/feature_structure.md) if you're adding a new feature,
and [Architecture](docs/architecture.md) if you want to understand how the layers connect.

---

## Getting started

```bash
flutter pub get
flutter run
```

Firebase is already configured — `lib/firebase_options.dart` and `android/app/google-services.json`
are committed and safe to use as-is.
