import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/app/app.locator.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';


class SignInViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();

  @override
  void setOnModelReadyCalled(ready) {
    print('Model Ready');
    isLoggedIn();
  }

  bool isLoggedIn() {
    print('isLoggedIn ${_authService.hasUser}');
    return _authService.hasUser;
  }

  void signInButtonPressed() async {
    await _authService.loginWithEmail(email: 'test@real.com', password: '123456hd');
    if (isLoggedIn()) {
      _nagivationService.navigateTo(Routes.globalView);
    }
  }

  void makeAccount() {
    _nagivationService.navigateTo(Routes.signUpView);
  }
  
}