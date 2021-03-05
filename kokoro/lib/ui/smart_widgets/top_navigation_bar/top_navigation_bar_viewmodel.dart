import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/app/app.locator.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:kokoro/core/services/navigation_bar_service.dart';

import 'package:kokoro/core/services/mock_auth_service.dart';


class TopNavigationBarViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _navigationBarService = locator<NavigationBarService>();
  final _authService = locator<MockAuthService>();

  final locations = [Routes.makePostView, Routes.homeView, Routes.globalView, Routes.historyView];

  int currentIndex() {
    return _navigationBarService.currentIndex;
  }

  void changeIndex(int index) {
    _navigationBarService.setCurrentIndex(index);
    print(_navigationService.currentRoute.isEmpty);
    if(_navigationService.currentRoute != locations[index]) {
      _navigationService.navigateTo(locations[index]);
    }
//    notifyListeners();
  }

  void signOut() {
    _authService.emailPasswordLogin('', '');
    _navigationService.navigateTo(Routes.signInView);
  }
}