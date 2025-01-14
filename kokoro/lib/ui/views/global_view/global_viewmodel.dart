import 'package:flutter_map/flutter_map.dart';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:kokoro/core/services/firebase_functions_service.dart';
import 'package:kokoro/core/services/user_information_service.dart';
import 'package:kokoro/ui/smart_widgets/global_location_item/global_location_item_view.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class GlobalViewModel extends BaseViewModel {
  int sideNavIndex = 0;
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseDatabaseService _databaseService = locator<FirebaseDatabaseService>();
  FirebaseFunctionsService _functionsService = locator<FirebaseFunctionsService>();
  UserInformationService _userInformationService = locator<UserInformationService>();

  MapController mapController;
  List<Marker> markers = [];
  List<Map> markerData = [];
  String userPlaceId;

  int flags = InteractiveFlag.all;
  double zoom = 2.4;
  double x = 0.0;
  double y = 0.0;
  LatLng center = LatLng(0.0, -30.0);
  LatLng prevCenter = LatLng(0.0, -30.0);
  double userColor = 360.0;
  double otherUserColor = 211.0;

  final Epsg3857 projection = Epsg3857();

  void init() {
    mapController = MapController();
    getInitialData();
  }

  void getInitialData() async {
    dynamic data = await _databaseService.getGlobalViewData(); // Gets all country data
    data = data.map<Map>((element) => element as Map).toList(); // Turns data into map format
    print(data);
    markerData = data;

    // Get user's placeId for comparison and mapping purposes
    dynamic userInfo = await _userInformationService.getUserInfo();
    dynamic personalInfo = await _databaseService.getUserInfo(uid: userInfo["uid"]);
    userPlaceId = personalInfo['location']['placeId'];

    markers = getMarkers(); // Gets map marker widgets for initial data
    notifyListeners(); // Re-draws map with new markers
  }

  void pointClicked(placeId) async {
    markers = []; // removes all previous markers
    notifyListeners();
    dynamic data = await _databaseService.getGlobalViewData(placeId: placeId); // Gets new data for clicked location
    data = data.map<Map>((element) => element as Map).toList();
    print(data);
    markerData = data;
    markers = getMarkers(); // Gets new markers for updated data
    print('pointClicked ${markerData}');
    notifyListeners();
  }

  // Returns marker widgets that show the dots on the map
  List<Marker> getMarkers() {
    return markerData.map<Marker>((element) { // Loops through markerData
      print('getMarkers ${element}');
      LatLng point = LatLng(element['lat'], element['lng']); // Gets point where marker will be placed

      if (element['placeId'] != userPlaceId) { // If the point is NOT the user's,
        return Marker(
          width: 500.0,
          height: 500.0,
          point: point,
          builder: (ctx) => Container(
            child: GlobalLocationItemView(
              intensity: element['normalizedUserCount'],
              zoom: zoom,
              location: element['placeId'],
              mapCallback: () { // When a point is clicked this function is called
                zoom = 5;
                mapController.move(point, 5); // Centers map on clicked point
                pointClicked(element['placeId']); // Updates markers
                notifyListeners(); // Re-draws with updated markers
              },
              hueColor: otherUserColor,
            ),
          ),
        );

      } else { // If user's point is found in set,
        // Set user's marker on map (unique red color from other points)
        return Marker(
          width: 500.0,
          height: 500.0,
          point: point,
          builder: (ctx) => Container(
            child: GlobalLocationItemView(
              intensity: element['normalizedUserCount'],
              zoom: zoom,
              location: element['placeId'],
              mapCallback: () { // When a point is clicked this function is called
                zoom = 5;
                mapController.move(point, 5); // Centers map on clicked point
                pointClicked(element['placeId']); // Updates markers
                notifyListeners(); // Re-draws with updated markers
              },
              hueColor: userColor,
            ),
          ),
        );
      }
    }).toList(); // Converts map to list
  }

  void dispose() {}

  void onPointerHover(PointerHoverEvent pointerHoverEvent) {
    x = pointerHoverEvent.position.dx;
    y = pointerHoverEvent.position.dy;
  }

  void onPointerSignal(PointerSignalEvent pointerSignalEvent, RenderBox renderBox) {
    if (pointerSignalEvent is PointerScrollEvent) {
      Offset localOffset = renderBox.globalToLocal(Offset(x, y));
      LatLng projected = latLngFromLocalOffset(renderBox, localOffset, zoom);
      if (pointerSignalEvent.scrollDelta.dy < 0 && 15 > mapController.zoom) {
        zoom += .4;
        LatLng newCenter = centerFromLocalOffsetAndLatLng(renderBox, localOffset, projected, zoom);
        mapController.move(newCenter, mapController.zoom + .4);
      } else if (pointerSignalEvent.scrollDelta.dy > 0 &&
          mapController.zoom > 1) {
        zoom -= .4;
        LatLng newCenter = centerFromLocalOffsetAndLatLng(renderBox, localOffset, projected, zoom);
        mapController.move(newCenter, mapController.zoom - .4);
      }
    }
  }

  void onPointerDown(PointerDownEvent pointerDownEvent, RenderBox renderBox) {
//    print('PointerDown');
//    Offset localOffset = renderBox.globalToLocal(Offset(x, y));
//    LatLng finalCenterLatLng = latLngFromLocalOffset(renderBox, localOffset, zoom);
//    animatedZoomIn(finalCenterLatLng, 6, renderBox);
  }

  void animatedZoomIn(LatLng finalCenterLatLng, double finalZoom, RenderBox renderBox) async {
    Offset currentCenter = localOffsetFromLatLng(renderBox, mapController.center, zoom);
    Offset finalCenter = localOffsetFromLatLng(renderBox, finalCenterLatLng, zoom);

    Offset diff = finalCenter - currentCenter;
    double m = diff.dy / diff.dx;
    Function line = (_x) => (m * (_x - currentCenter.dx) + currentCenter.dy);
    List<LatLng> pointsOnLine = [];
    double interval = diff.dx / 20;
    double zoomDiff = (finalZoom - zoom);

    for (int i = 0; i < 20; i++) {
//      interval = (diff.dx / (i + 2));
      double inX = (interval * (i + 1)) + currentCenter.dx;

      print(latLngFromLocalOffset(renderBox, Offset(inX, line(inX)), zoom));
      pointsOnLine.add(latLngFromLocalOffset(renderBox, Offset(inX, line(inX)), zoom));
      print(Offset(inX, line(inX)));
    }


    double currZoom = zoom;
    double zoomInterval = (finalZoom - zoom) / 20;
    for (int i = 0; i < 20; i++) {
      print(pointsOnLine[i]);
//      zoomInterval = .5 * (zoomDiff / pow(i + 1, i));
      print(zoomInterval);
      mapController.move(pointsOnLine[i], zoom + (zoomInterval));
      zoom += zoomInterval;
      await Future.delayed(const Duration(milliseconds: 10), (){});
    }

  }

  LatLng centerFromLocalOffsetAndLatLng(RenderBox renderBox, Offset localOffset, LatLng latLng, double _zoom) {
    Offset localOffset = renderBox.globalToLocal(Offset(x, y));
    double width = renderBox.size.width;
    double height = renderBox.size.height;

    CustomPoint localPoint = CustomPoint(localOffset.dx, localOffset.dy);
    CustomPoint localPointCenterDistance =
    CustomPoint((width / 2) - localPoint.x, (height / 2) - localPoint.y);

    CustomPoint point = projection.latLngToPoint(latLng, _zoom);
    CustomPoint mapCenter = point + localPointCenterDistance;
    return projection.pointToLatLng(mapCenter, _zoom);
  }

  Map localOffsetAndLatLngFromCenter(LatLng latLng, double _zoom) {
    CustomPoint point = projection.latLngToPoint(latLng, _zoom);
  }

  LatLng latLngFromLocalOffset(RenderBox renderBox, Offset localOffset, double _zoom) {
//    Offset localOffset = renderBox.globalToLocal(Offset(x, y));
    double width = renderBox.size.width;
    double height = renderBox.size.height;

    CustomPoint localPoint = CustomPoint(localOffset.dx, localOffset.dy);
    CustomPoint localPointCenterDistance =
    CustomPoint((width / 2) - localPoint.x, (height / 2) - localPoint.y);

    CustomPoint mapCenter =
    projection.latLngToPoint(mapController.center, _zoom);
    CustomPoint point = mapCenter - localPointCenterDistance;
    return projection.pointToLatLng(point, _zoom);
  }

  Offset localOffsetFromLatLng(RenderBox renderBox, LatLng latLng, double _zoom) {
    double width = renderBox.size.width;
    double height = renderBox.size.height;

    CustomPoint point = projection.latLngToPoint(latLng, _zoom);
    CustomPoint mapCenter =
    projection.latLngToPoint(mapController.center, _zoom);
    CustomPoint localPointCenterDistance = mapCenter - point;
    Offset localPoint = Offset((width / 2) - localPointCenterDistance.x, (height / 2) - localPointCenterDistance.y);
    return localPoint;
  }

  void buttonPressed(int index) async {
    if(index == 0) {
      _navigationService.navigateTo(Routes.planetView);
    } else if(index == 1) {
      // TODO: Get user info not working... client offline...need to find out
//      dynamic userInfo = await _userInformationService.getUserInfo();
//      print('PERSONAL MAP DATA: '
//          '${await _functionsService.getPersonalMapData(userInfo["uid"],
//          DateTime.utc(2020, 1, 1), DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day))}');
//      _functionsService.makePlanetUsedImagesCollection();
      _navigationService.navigateTo(Routes.personalView);
    }
  }
}