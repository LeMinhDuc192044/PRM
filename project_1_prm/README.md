# project_1_prm

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Lab 3 E2E Testing

Patrol tests are located in `patrol_test/`.

AI code review evidence is available in `docs/AI_CODE_REVIEW_EVIDENCE.md`.

Run on Android:

```bash
patrol test --target patrol_test/app_smoke_test.dart --device <device-id> --package-name com.example.project_1_prm
```

Run on iOS:

```bash
patrol test --target patrol_test/app_smoke_test.dart --device <simulator-name> --bundle-id com.example.project1Prm
```
