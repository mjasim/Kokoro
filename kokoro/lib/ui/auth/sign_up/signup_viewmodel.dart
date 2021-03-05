import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';

class SignUpViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authServie = locator<FirebaseAuthService>();

  void makeAccount(String email, String password) {
    var results = _authServie.createAccountWithEmail(email: email, password: password);
  }

  void goToLogIn() {
    _nagivationService.navigateTo(Routes.signInView);
  }
}