import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:kokoro/ui/smart_widgets/personal_location_item/personal_location_item_view.dart';
import 'package:kokoro/ui/views/personal_view/personal_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class PersonalMapView extends ViewModelWidget<PersonalViewModel> {
  @override
  bool get reactive => true;

  @override
  Widget build(BuildContext context, PersonalViewModel model) {
    return Listener(
      onPointerHover: (pointerHoverEvent) => model.onPointerHover(pointerHoverEvent),
      onPointerSignal: (pointerSignalEvent) {
        RenderBox renderBox = context.findRenderObject();
        model.onPointerSignal(pointerSignalEvent, renderBox);
      },
      onPointerDown: (pointerDownEvent) {
        RenderBox renderBox = context.findRenderObject();
        model.onPointerDown(pointerDownEvent, renderBox);
      },
      child: FlutterMap(
        mapController: model.mapController,
        options: MapOptions(
          center: model.center,
          zoom: model.zoom,
          interactiveFlags: model.flags,
        ),
        layers: [
          TileLayerOptions(
            updateInterval: 0,
            keepBuffer: 100,
            backgroundColor: Color.fromRGBO(38, 38, 38, 255),
            urlTemplate:
            "https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          TappablePolylineLayerOptions(
            // Will only render visible polylines, increasing performance

              polylineCulling: true,
              pointerDistanceTolerance: 20,
              polylines: _getPolylines(
                  getLines(model),
                  getLinesWidths(model),
                  getUserLocation(model)),
              onTap: (TaggedPolyline polyline) => print("TAGGED"), // TODO: Mod onTap to show people
              onMiss: () {
                print('No polyline was tapped');
              }),
          MarkerLayerOptions(
            markers: getMarkers(model),
          ),
        ],
      ),
    );
  }

  // Returns marker widgets that show the dots on the map
  List<Marker> getMarkers(PersonalViewModel model) {
    // Clear lists to ensure fresh start
    model.latLngListData.clear();
    model.lineWidths.clear();

    print("model.markerData: ${model.markerData}");

    return model.markerData.map<Marker>((placeData) { // Loops through markerData

      double count = placeData['count'] == null ? model.totalPopulation : placeData['count'];

      print("getMarkers() placeData: ${placeData}");
      print("getMarkers() placeData latLngData: ${placeData['latLngData']}");
      print("getMarkers() placeData location: ${placeData['location']}");
      //print("placeData latLngData lat: ${placeData['latLngData']['lat']}");
      //print("placeData latLngData lng: ${placeData['latLngData']['lng']}");

      LatLng point;
      if (placeData['latLngData'] == null) {
        point = LatLng(placeData['location']['cityLatLng']['lat'], placeData['location']['cityLatLng']['lng']); // Gets point where marker will be placed
      } else {
        point = LatLng(placeData['latLngData']['lat'], placeData['latLngData']['lng']); // Gets point where marker will be placed
      }

      print("point: ${point}");

      if (placeData['placeId'] != model.userPlaceId) { // If the point is NOT the user's,
        // Add point coordinates to list that is NOT personal location
        model.latLngListData.add(point);

        // Add line width between point and user
        model.lineWidths.add((count/model.totalPopulation) * model.maxLineWidth);

        return Marker(
          width: 100.0,
          height: 100.0,
          point: point,
          builder: (ctx) => Container(
            child: PersonalLocationItemView(
              intensity: /*(placeData['count']*/ count/model.totalPopulation,
              zoom: model.zoom,
              location: placeData['placeId'],
              mapCallback: () { // When a point is clicked this function is called
                model.zoom = 5;
                model.mapController.move(point, 5); // Centers map on clicked point
                model.pointClicked(placeData['placeId']); // Updates markers
                model.notifyListeners(); // Re-draws with updated markers
              },
              hasClickedOnLine: true,
              hueColor: model.otherUserColor,
            ),
          ),
        );
      } else { // If user's point is found in set,
        model.userLocation = point; // Save user's location

        // Set user's marker on map (unique red color from other points)
        return Marker(
          width: 100.0,
          height: 100.0,
          point: point,
          builder: (ctx) => Container(
            child: PersonalLocationItemView(
              intensity: (count/model.totalPopulation),
              zoom: model.zoom,
              location: placeData['placeId'],
              mapCallback: () { // When a point is clicked this function is called
                model.zoom = 5;
                model.mapController.move(point, 5); // Centers map on clicked point
                model.pointClicked(placeData['placeId']); // Updates markers
                model.notifyListeners(); // Re-draws with updated markers
              },
              hasClickedOnLine: true,
              hueColor: model.userColor,
            ),
          ),
        );
      }

    }).toList(); // Converts map to list
  }

  // Return list of line pairs on the map (excluding current user's location)
  List<LatLng> getLines(PersonalViewModel model) {
    if (model.latLngListData == null) { // If list is empty, get markers to fill up data
      getMarkers(model);
    }
    return model.latLngListData;
  }

  // Return list of line widths on the map (excluding current user's location)
  List<double> getLinesWidths(PersonalViewModel model) {
    if (model.lineWidths == null) { // If list is empty, get markers to fill up data
      getMarkers(model);
    }
    return model.lineWidths;
  }

  // Get current user's LatLng location
  LatLng getUserLocation(PersonalViewModel model) {
    if (model.userLocation == null) { // If list is empty, get markers to fill up data
      getMarkers(model);
    }
    return model.userLocation;
  }
}

// Get list of lines from current user to all other users
List<TaggedPolyline> _getPolylines(
    List<LatLng> latLngListData, List<double> lineWidths, LatLng userLocation) {
  List<TaggedPolyline> polylines = [];

  // Get the list of all possible pairs of lines from current user to other users
  List<List<LatLng>> lineList = [];
  latLngListData.forEach((element) {
    List<LatLng> line = [];
    line.add(userLocation);
    line.add(element);
    lineList.add(line);
  });

  // Get each pair of lines from current user to all other users
  for (var i = 0; i < lineList.length; i++) {
    polylines.add(
      TaggedPolyline(
        points: lineList[i],
        color: Colors.red,
        strokeWidth: lineWidths[i],
      ),
    );
  }

  return polylines;
}
