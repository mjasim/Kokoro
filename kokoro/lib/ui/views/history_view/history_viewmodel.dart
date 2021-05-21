import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:kokoro/core/services/firebase_functions_service.dart';
import 'package:kokoro/core/services/user_information_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class HistoryViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseDatabaseService _databaseService = locator<FirebaseDatabaseService>();
  FirebaseFunctionsService _functionsService = locator<FirebaseFunctionsService>();
  UserInformationService _userInformationService = locator<UserInformationService>();


  Map personalHistoryData = {};
  Map userInfo = {"id": "hero", "img": "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png"};
  void init() {

  }

  void changeUserInfo() async {
    if (userInfo['img'] == "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png") {
      userInfo['img'] = "https://images.generated.photos/Co_dgV-4Fusp2NjQFaQKvY_NQDmo8HZjyyqbMpbbEog/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzNTcxMjYuanBn.jpg";
    } else {
      userInfo['img'] = "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png";
    }

    Map _userInfo = await _userInformationService.getUserInfo();

    _functionsService.getPersonalHistoryData(_userInfo['uid'], 'kYlCxhFZcur1FGxXp5zA3WLx3nPm', DateTime.utc(2021, 4, 1), DateTime.utc(2021, 4, 20));
    notifyListeners();
  }

}