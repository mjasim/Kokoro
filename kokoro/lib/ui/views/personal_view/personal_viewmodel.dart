import 'dart:math';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/core/services/firebase_functions_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:kokoro/core/services/user_information_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kokoro/ui/smart_widgets/personal_location_item/personal_location_item_view.dart';
import 'package:stacked/stacked.dart';
import 'package:latlong/latlong.dart';
import 'package:stacked_services/stacked_services.dart';

class PersonalViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseDatabaseService _databaseService = locator<FirebaseDatabaseService>();
  FirebaseFunctionsService _functionsService = locator<FirebaseFunctionsService>();
  UserInformationService _userInformationService = locator<UserInformationService>();

  MapController mapController;
  List<Marker> markers = []; // List of markers on the map
  List<Map> markerData = []; // List of marker's data
  List<Map> profileUrlData = []; // List of marker's profile pic url data
  List<LatLng> latLngListData = []; // List of location lat/lng of points
  List<LatLng> lines = []; // List of lines between points (current user to other user)
  List<double> lineWidths = []; // List of line widths between points
  final double maxLineWidth = 5.0; // Max width of line on map between points
  String clickedPlaceId = "";

  int totalPopulation = 0;
  String userPlaceId; // User's location placeId
  LatLng userLocation = null;

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

    // Get outgoing data
    dynamic outGoingData = await getAllCityLatLogAndInteractCounts(
        "outgoing",
        DateTime.utc(2020, 1, 1),
        DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    // Get incoming data
    dynamic incomingData = await getAllCityLatLogAndInteractCounts(
        "incoming",
        DateTime.utc(2020, 1, 1),
        DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    // Map that will get all interactions from both outgoing and incoming data
    Map mergeData = {};

    // Gather outgoing data and add to mergeData
    outGoingData.forEach((placeId, placeData) {
      mergeData[placeId] = placeData;
    });

    // Gather incoming data and add to mergeData
    incomingData.forEach((placeId, placeData) {
      if (mergeData.containsKey(placeId)) {
        mergeData[placeId]["count"] += placeData["count"];
      } else {
        mergeData[placeId] = placeData;
      }
    });

    markerData = mergeData.values.map<Map>((element) => element as Map).toList();

    // Get the total count of population for scaling point intensity
    for (int i = 0; i < markerData.length; i++) {
      totalPopulation += markerData[i]['count'];
    }

    // Get user's placeId for comparison and mapping purposes
    dynamic userInfo = await _userInformationService.getUserInfo();
    dynamic personalInfo = await _databaseService.getUserInfo(uid: userInfo["uid"]);
    userPlaceId = personalInfo['location']['placeId'];

    //markers = getMarkers(); // Gets map marker widgets for initial data
    notifyListeners();      // Re-draws map with new markers
  }

  void pointClicked(placeId) async {
    clickedPlaceId = placeId;



//    markers = []; // removes all previous markers
//    markerData = []; // removes any markerData
//    notifyListeners();
//    dynamic data = await _databaseService.getGlobalViewData(placeId: placeId); // Gets new data for clicked location
//    data = data.map<Map>((element) => element as Map).toList();
//    print(data);
//    markerData = data;
//    //markers = getMarkers(); // Gets new markers for updated data
//    print('pointClicked ${markerData}');
//    notifyListeners();
  }

  void getListOfProfileUrls(placeId) async {
    profileUrlData = [];

    dynamic urlData = await getProfileData(
        placeId,
        DateTime.utc(2020, 1, 1),
        DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    // Populate profileUrlData with list of profile photo urls from location
    urlData.forEach((element) {
      profileUrlData.add(element['profilePhotoUrl']); // TODO: Need to find out how to get list of urls
    });

    notifyListeners();
  }

  // Returns marker widgets that show the dots on the map
  List<Marker> getMarkers() {
    // Clear lists to ensure fresh start
    latLngListData.clear();
    lineWidths.clear();

    return markerData.map<Marker>((placeData) { // Loops through markerData
      LatLng point = LatLng(placeData['latLngData']['lat'], placeData['latLngData']['lng']); // Gets point where marker will be placed
      if (placeData['placeId'] != userPlaceId) { // If the point is NOT the user's,
        // Add point coordinates to list that is NOT personal location
        latLngListData.add(point);

        // Add line width between point and user
        lineWidths.add((placeData['count']/totalPopulation) * maxLineWidth);

        return Marker(
          width: 100.0,
          height: 100.0,
          point: point,
          builder: (ctx) => Container(
            child: PersonalLocationItemView(
              intensity: (placeData['count']/totalPopulation),
              zoom: zoom,
              location: placeData['placeId'],
              mapCallback: () { // When a point is clicked this function is called
                zoom = 5;
                mapController.move(point, 5); // Centers map on clicked point
                pointClicked(placeData['placeId']); // Updates markers
                notifyListeners(); // Re-draws with updated markers
              },
              hasClickedOnLine: true,
              hueColor: otherUserColor,
            ),
          ),
        );
      } else { // If user's point is found in set,
        userLocation = point; // Save user's location

        // Set user's marker on map (unique red color from other points)
        return Marker(
          width: 100.0,
          height: 100.0,
          point: point,
          builder: (ctx) => Container(
            child: PersonalLocationItemView(
              intensity: (placeData['count']/totalPopulation),
              zoom: zoom,
              location: placeData['placeId'],
              mapCallback: () { // When a point is clicked this function is called
                zoom = 5;
                mapController.move(point, 5); // Centers map on clicked point
                pointClicked(placeData['placeId']); // Updates markers
                notifyListeners(); // Re-draws with updated markers
              },
              hasClickedOnLine: true,
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

      // If center is too far away, lock center at a certain boundary
    }
  }

  void onPointerDown(PointerDownEvent pointerDownEvent, RenderBox renderBox) {
//    print('PointerDown');
//    Offset localOffset = renderBox.globalToLocal(Offset(x, y));
//    LatLng finalCenterLatLng = latLngFromLocalOffset(renderBox, localOffset, zoom);
//    animatedZoomIn(finalCenterLatLng, 6, renderBox);
  }

  // Animated zoom in from current center of map to new center of map
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

  // Get personalMapData (note: startDate & stopdate = DateTime.utc(yyyy, mm, dd))
  Future<Map> userPersonalMapData(startDate, stopDate) async {
    dynamic userInfo = await _userInformationService.getUserInfo();
    return await _functionsService.getPersonalMapData(
        userInfo["uid"], startDate, stopDate);
  }

  // Example:
  // personalMapData["userInfo"].map((key, value) { return MapEntry(key, value["username"]) });

  // Gets list of cities with their latitude, longitude, placeId,
  // population count, and whether it is opened or not by click of cursor.
  Future<Map> getAllCityLatLogAndInteractCounts(String inOut, startDate, stopDate) async {
    dynamic personalMapData = await userPersonalMapData(startDate, stopDate);
    Map cityMapLocationAndCount = personalMapData[inOut].map((placeId, placeData) {
      int totalCount = 0;
      placeData.forEach((userId, count) {
        totalCount += count;
      });

      dynamic cityLatLngData = personalMapData["locationInfo"][placeId]["cityLatLng"];

      // Map placeID with its lat/lng, and total count of interactions
      return MapEntry(placeId,
          {"latLngData": cityLatLngData,
            "count": totalCount,
            "placeId": placeId,
            "isOpened": false
          });
    });

    return cityMapLocationAndCount;
  }

  bool isClicked = false;

  void clicked(mapCallback) {
    isClicked = !isClicked;
    print('clicked: ${isClicked}, zoom: ${zoom}');
    if(zoom < 5 && isClicked) {
      print('clicked Callback');
      mapCallback();
    }
    notifyListeners();
  }

  void setZoom(z) {
    zoom = z;
  }

  // Call the backend to access profileUrls for the accounts at the given location.
  Future<List<Map>> getProfileData(String locationId, startDate, stopDate) async {

    List<Map> profileUrlList = [];

    dynamic personalMapData = await userPersonalMapData(startDate, stopDate);
    dynamic incomingProfileList = personalMapData["incoming"][locationId];
    dynamic outgoingProfileList = personalMapData["outgoing"][locationId];
    dynamic userInfoData = personalMapData["userInfo"];

    print('Incoming: ${incomingProfileList}');
    print('Outgoing: ${outgoingProfileList}');

    if (incomingProfileList != null) {
      incomingProfileList.forEach((userId, count) { // Go through all profiles for that location
        // Get user's profile url
        //print('userInfoData[userId]: ${userInfoData[userId]}');
        profileUrlList.add(userInfoData[userId]);
      });
    }

    if (outgoingProfileList != null) {
      outgoingProfileList.forEach((userId, count) { // Go through all profiles for that location
        // Get user's profile url
        if (!profileUrlList.contains(userId)){
          //print('userInfoData[userId]: ${userInfoData[userId]}');
          profileUrlList.add(userInfoData[userId]);
        }
      });
    }

    print('PROFILE URL LIST: ${profileUrlList}');

    return profileUrlList;
  }

}
