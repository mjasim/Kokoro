import 'package:latlong/latlong.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:kokoro/core/services/global_map_service.dart';

class GlobalMapViewModel extends BaseViewModel {
  final _globalMapService = locator<GlobalMapService>();
  double zoom = 2.5;
  LatLng center = LatLng(0.0, -30.0);

  List<Map> getData(zoomLevel) {
    return _globalMapService.getData(zoomLevel);
  }

  void updateMapView() {
    center = LatLng(50.0, -30.0);
    zoom = 10;
    notifyListeners();
  }
}