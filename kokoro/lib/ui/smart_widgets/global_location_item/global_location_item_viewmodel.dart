import 'package:stacked/stacked.dart';

class GlobalLocationItemViewModel extends BaseViewModel {
  bool isClicked = false;

  void clicked() {
    isClicked = !isClicked;
    notifyListeners();
  }

}