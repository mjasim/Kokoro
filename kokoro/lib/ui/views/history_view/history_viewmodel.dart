import 'package:stacked/stacked.dart';

class HistoryViewModel extends BaseViewModel {

  Map personalHistoryData = {};
  Map userInfo = {"id": "hero", "img": "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png"};
  void init() {

  }

  void changeUserInfo() {
    if (userInfo['img'] == "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png") {
      userInfo['img'] = "https://images.generated.photos/Co_dgV-4Fusp2NjQFaQKvY_NQDmo8HZjyyqbMpbbEog/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzNTcxMjYuanBn.jpg";
    } else {
      userInfo['img'] = "http://marvel-force-chart.surge.sh/marvel_force_chart_img/top_captainamerica.png";
    }

    notifyListeners();
  }

}