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
  double zoom = 2.4;
  double x = 0.0;
  double y = 0.0;
  LatLng center = LatLng(0.0, -30.0);
  CustomPoint leftCorner;
  final Epsg3857 projection = Epsg3857();

  List<Marker> markers;
  StreamSubscription<MapEvent> subscription;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    subscription = mapController.mapEventStream.listen(onMapEvent);
    markers = [];
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
      builder: (context, model, child) {
        markers = getMarkers(model.getData(zoom), zoom, model);
        return Listener(
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

                mapController.move(projected, mapController.zoom + .4);
                setState(() {
                  zoom = mapController.zoom;
                  markers = getMarkers(model.getData(zoom), zoom, model);
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

                mapController.move(projected, mapController.zoom - .4);
                setState(() {
                  zoom = mapController.zoom;
                  markers = getMarkers(model.getData(zoom), zoom, model);
                });
              }
            }
          },
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: center,
              zoom: zoom,
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
        );
      },
      viewModelBuilder: () => GlobalMapViewModel(),
    );
  }

  List<Marker> getMarkers(data, _zoom, model) {
    return data.map<Marker>((element) {
      LatLng point = LatLng(element['lat'], element['lon']);
      print(point);
      print(element['location']);
      return Marker(
        width: 500.0,
        height: 500.0,
        point: point,
        builder: (ctx) => Container(
          child: GlobalLocationItemView(
            intensity: element['activity'],
            zoom: _zoom,
            location: element['location'],
            mapCallback: () {
              print(element['location']);
              setState(() {
                zoom = 5;
                mapController.move(point, 5);
              });
            },
          ),
        ),
      );
    }).toList();
  }
}
