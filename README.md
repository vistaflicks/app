# vista_flicks

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


=============================================================== For Mac user ===============================================================
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs && dart run easy_localization:generate  --source-dir assets/lang/ -f keys -O lib/ui/utils/theme  --output-file app_strings.g.dart && dart pub global activate flutter_gen && fluttergen


=============================================================== For Window user ===============================================================

flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run easy_localization:generate --source-dir assets/lang/ -f keys -O lib/ui/utils/theme --output-file app_strings.g.dart
dart pub global activate flutter_gen
fluttergen
