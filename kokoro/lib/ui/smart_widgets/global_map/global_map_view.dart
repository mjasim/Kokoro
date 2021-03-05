import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:kokoro/ui/smart_widgets/global_location_item/global_location_item_view.dart';
import 'package:kokoro/ui/smart_widgets/global_map/global_map_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';

class GlobalMapView extends StatefulWidget {
  @override
  _GlobalMapViewState createState() => _GlobalMapViewState();
}

class _GlobalMapViewState extends State<GlobalMapView> {
  MapController mapController;

  int flags = InteractiveFlag.all;
  double zoom = 1.0;
  double x = 0.0;
  double y = 0.0;
  CustomPoint leftCorner;
  final Epsg3857 projection = Epsg3857();

  List<Marker> markers;
  StreamSubscription<MapEvent> subscription;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    subscription = mapController.mapEventStream.listen(onMapEvent);
    markers = getMarkers(zoom);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is! MapEventMove && mapEvent is! MapEventRotate) {
      print(mapEvent);
    }
  }

  void updateFlags(int flag) {
    if (InteractiveFlag.hasFlag(flags, flag)) {
      flags &= ~flag;
    } else {
      flags |= flag;
    }
  }

  void _updateMousePosition(PointerHoverEvent event) {}

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GlobalMapViewModel>.reactive(
      builder: (context, model, child) => Listener(
        onPointerHover: (pointerHover) {
          if (pointerHover is PointerHoverEvent) {
            x = pointerHover.position.dx;
            y = pointerHover.position.dy;
          }
        },
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            if (pointerSignal.scrollDelta.dy < 0 && 15 > mapController.zoom) {
              RenderBox getBox = context.findRenderObject();
              var local = getBox.globalToLocal(Offset(x, y));
              var localPoint = CustomPoint(local.dx, local.dy);
              var width = getBox.size.width;
              var height = getBox.size.height;
              var localPointCenterDistance = CustomPoint(
                  (width / 2) - localPoint.x, (height / 2) - localPoint.y);

              var mapCenter =
                  projection.latLngToPoint(mapController.center, zoom + 1);
              var point = mapCenter - localPointCenterDistance;
              var projected = projection.pointToLatLng(point, zoom + 1);

              mapController.move(projected, mapController.zoom + 1);
              setState(() {
                zoom = mapController.zoom;
                markers = getMarkers(zoom);
              });
            } else if (pointerSignal.scrollDelta.dy > 0 &&
                mapController.zoom > 1) {
              RenderBox getBox = context.findRenderObject();
              var local = getBox.globalToLocal(Offset(x, y));
              var localPoint = CustomPoint(local.dx, local.dy);
              var width = getBox.size.width;
              var height = getBox.size.height;
              var localPointCenterDistance = CustomPoint(
                  (width / 2) - localPoint.x, (height / 2) - localPoint.y);

              var mapCenter =
                  projection.latLngToPoint(mapController.center, zoom);
              var point = mapCenter - localPointCenterDistance;
              var projected = projection.pointToLatLng(point, zoom);

              mapController.move(projected, mapController.zoom - 1);
              setState(() {
                zoom = mapController.zoom;
                markers = getMarkers(zoom);
              });
            }
          }
        },
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onPositionChanged: (MapPosition position, bool text) {
              leftCorner =
                  projection.latLngToPoint(position.bounds.northWest, zoom);
              print(
                  'MapPosition ${projection.latLngToPoint(position.bounds.northWest, zoom)}');
            },
            center: LatLng(51.5, -0.09),
            zoom: 1.0,
            interactiveFlags: flags,
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
            MarkerLayerOptions(
              markers: markers,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => GlobalMapViewModel(),
    );
  }

  List<Marker> getMarkers(double zoom) {
    if (zoom <= 4) {
      return [
        Marker(
          width: (1 - ((16.0 - zoom) / 15)) * 80.0,
          height: (1 - ((16.0 - zoom) / 15)) * 80.0,
          point: LatLng(51.5, -0.09),
          builder: (ctx) => Container(
            child: GlobalLocationItemView(),
          ),
        ),
      ];
    } else {
      return [
        Marker(
          width: (1 - ((16.0 - zoom) / 15)) * 80.0,
          height: (1 - ((16.0 - zoom) / 15)) * 80.0,
          point: LatLng(51.8, -0.03),
          builder: (ctx) => Container(
            child: GlobalLocationItemView(),
          ),
        ),
        Marker(
          width: (1 - ((16.0 - zoom) / 15)) * 80.0,
          height: (1 - ((16.0 - zoom) / 15)) * 80.0,
          point: LatLng(51.0, -0.14),
          builder: (ctx) => Container(
            child: GlobalLocationItemView(),
          ),
        ),
        Marker(
          width: (1 - ((16.0 - zoom) / 15)) * 80.0,
          height: (1 - ((16.0 - zoom) / 15)) * 80.0,
          point: LatLng(51.3, -0.16),
          builder: (ctx) => Container(
            child: GlobalLocationItemView(),
          ),
        ),
      ];
    }
  }
}
