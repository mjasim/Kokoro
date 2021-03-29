import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/app/app.locator.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GlobalViewModel extends BaseViewModel {
  int sideNavIndex = 0;
  NavigationService _navigationService = locator<NavigationService>();

  void buttonPressed(int index) {
    if(index == 0) {
      _navigationService.navigateTo(Routes.planetView);
    } else if(index == 1) {
      _navigationService.navigateTo(Routes.personalView);
    }
  }

}