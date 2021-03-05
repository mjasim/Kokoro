# kokoro

To update routes and locator put the information in the `app.dart` file. Then run:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
This will generate the code needed to access these routes.
