import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:flutter_map/flutter_map.dart';
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
                  model.getLines(),
                  model.getLinesWidths(),
                  model.getUserLocation()),
              onTap: (TaggedPolyline polyline) => print(polyline.tag),
              onMiss: () {
                print('No polyline was tapped');
              }),
          MarkerLayerOptions(
            markers: model.markers,
          ),
        ],
      ),
    );
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