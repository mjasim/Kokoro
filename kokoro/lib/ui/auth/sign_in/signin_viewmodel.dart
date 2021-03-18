import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/app/app.locator.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';


class SignInViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();

  bool isLoggedIn() {
    print('isLoggedIn ${_authService.hasUser}');
    return _authService.hasUser;
  }

  void signInButtonPressed(email, password) async {
    await _authService.loginWithEmail(email: email, password: password);
    if (isLoggedIn()) {
      _nagivationService.navigateTo(Routes.globalView);
    }
  }

  void makeAccount() {
    _nagivationService.navigateTo(Routes.signUpView);
  }

  void navigateToGlobalView() {
    _nagivationService.navigateTo(Routes.globalView);
  }
  
}