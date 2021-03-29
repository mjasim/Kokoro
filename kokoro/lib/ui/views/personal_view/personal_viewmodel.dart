import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stacked/stacked.dart';
import 'package:latlong/latlong.dart';

class PersonalViewModel extends BaseViewModel {
  MapController mapController;
  List<Marker> markers = [];

  int flags = InteractiveFlag.all;
  double zoom = 2.4;
  double x = 0.0;
  double y = 0.0;
  LatLng center = LatLng(0.0, -30.0);
  LatLng prevCenter = LatLng(0.0, -30.0);

  final Epsg3857 projection = Epsg3857();

  void init() {
    mapController = MapController();
  }

  void dispose() {}

  void onPointerHover(PointerHoverEvent pointerHoverEvent) {
    x = pointerHoverEvent.position.dx;
    y = pointerHoverEvent.position.dy;
  }

  void onPointerSignal(
      PointerSignalEvent pointerSignalEvent, RenderBox renderBox) {
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
    print('PointerDown');
    Offset localOffset = renderBox.globalToLocal(Offset(x, y));
    LatLng finalCenterLatLng = latLngFromLocalOffset(renderBox, localOffset, zoom);
    animatedZoomIn(finalCenterLatLng, 6, renderBox);
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
}
