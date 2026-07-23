# AI Code Review Evidence

Date: 2026-07-22

## Scope

This review covers the Lab 3 upgrade of the existing Lab 2 Flutter project. The work preserved the existing reader workflow and added Firebase/Auth/Profile/Storage/Analytics/Crashlytics/FCM/Remote Config/PDF export/Patrol evidence incrementally.

## Architecture Review

- Existing reader behavior was preserved in `lib/main.dart`.
- New business logic was moved into services and ViewModels instead of widget callbacks.
- Provider remains the state-management mechanism.
- Firebase-dependent services are guarded so the app can still run before Firebase config files are added.
- Profile, notifications, export, monitoring, and remote config were added as extensions rather than a rewrite.

## Lab 3 Requirement Evidence

| Requirement | Evidence |
| --- | --- |
| Firebase Authentication | `lib/services/auth_service.dart`, `lib/viewmodels/auth_view_model.dart` |
| Google Sign-In | `AuthService.signInWithGoogle()` uses `GoogleSignIn` + `GoogleAuthProvider` |
| Firebase Storage | `lib/services/storage_service.dart` uploads exported PDFs |
| Firebase Analytics | `lib/services/app_monitoring_service.dart` logs app open/login/sign-out and route views |
| Firebase Cloud Messaging | `lib/services/notification_service.dart`, `lib/screens/notification_center_screen.dart` |
| Firebase Crashlytics | `AppMonitoringService.initialize()` registers Flutter/platform error handlers |
| Firebase Remote Config | `lib/services/remote_config_service.dart`, `lib/viewmodels/remote_config_view_model.dart` |
| PDF Export | `lib/services/pdf_export_service.dart`, `lib/viewmodels/export_view_model.dart` |
| Profile page | `lib/screens/profile_screen.dart` |
| Notification Center | `lib/screens/notification_center_screen.dart` |
| Patrol E2E tests | `patrol_test/app_smoke_test.dart`, `patrol.yaml` |
| AI Code Review evidence | `docs/AI_CODE_REVIEW_EVIDENCE.md` |

## Review Findings

- No large rewrite was introduced; the app remains functionally centered on the existing reader.
- New feature logic is isolated from UI where practical.
- Firebase initialization is tolerant of missing config, reducing setup friction during grading.
- Patrol tests avoid real Google/Firebase credentials and cover stable smoke flows.
- Remaining architectural debt: the original reader is still monolithic and should eventually be split into reader-specific service/viewmodel/widgets.

## Validation Evidence

Commands run:

```bash
flutter analyze
flutter test
```

Result:

```text
No issues found!
All tests passed!
```

Patrol execution note:

```bash
patrol test --target patrol_test/app_smoke_test.dart --device <device-id>
```

Full Patrol execution requires an Android emulator/device or iOS simulator. Host-only `flutter test patrol_test` is not supported by Patrol native routing on this Windows environment.

## External Setup Required

- Add Firebase app config files such as `android/app/google-services.json`.
- Enable Google Sign-In in Firebase Authentication.
- Configure SHA-1/SHA-256 fingerprints for Android Google Sign-In.
- Create Firebase Storage security rules appropriate for authenticated users.
- Enable Analytics, Crashlytics, Cloud Messaging, and Remote Config in Firebase Console.
