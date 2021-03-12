import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';

class SignUpViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();

  void makeAccount(String email, String password, String location,
                   String name, String birthday, String gender) {
    print("Email:    ${email}");
    print("Password: ${password}");
    print("Location: ${location}");
    print("Name:     ${name}");
    print("Birthday: ${birthday}");
    print("Gender:   ${gender}");
//    var results = _authService.createAccountWithEmail(email: email, password: password);
  }

  void goToLogIn() {
    _nagivationService.navigateTo(Routes.signInView);
  }
}