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

class _GlobalMapViewState extends State<GlobalMapView>
    with AutomaticKeepAliveClientMixin {
  MapController mapController;

  int flags = InteractiveFlag.all;
  double zoom = 2.4;
  double x = 0.0;
  double y = 0.0;
  LatLng center = LatLng(0.0, -30.0);
  LatLng prevCenter = LatLng(0.0, -30.0);

  CustomPoint leftCorner;
  final Epsg3857 projection = Epsg3857();

  List<Marker> markers; // List of markers placed on the map
  StreamSubscription<MapEvent> subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    subscription = mapController.mapEventStream.listen(onMapEvent);
    markers = []; // Marker initialized to be empty
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is! MapEventMove && mapEvent is! MapEventRotate) {
//      print(mapEvent);
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
//        markers = getMarkers(model.getData(zoom), zoom, model);
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
                print("$x, $y");
                var local = getBox.globalToLocal(Offset(x, y));
                print(local);
                var localPoint = CustomPoint(local.dx, local.dy);
                var width = getBox.size.width;
                var height = getBox.size.height;
                print("width: $width, height: $height");
                var localPointCenterDistance = CustomPoint(
                    (width / 2) - localPoint.x, (height / 2) - localPoint.y);

                var mapCenter =
                    projection.latLngToPoint(mapController.center, zoom);
                var point = mapCenter - localPointCenterDistance;
                var projected = projection.pointToLatLng(point, zoom);

                print('Prev center: ${mapController.center}, Prev Zoom: ${mapController.zoom}');


                mapController.move(projected, mapController.zoom + .4); // Moves center of map; allows to zoom in and zoom out
                print('center: ${mapController.center}, Zoom: ${mapController.zoom}');
                setState(() {
                  zoom = mapController.zoom;
                  var _markers = getMarkers(model.getData(zoom), zoom, model);
//                  print(_markers);
//                  _markers.add(
//                    Marker(
//                      width: 100.0,
//                      height: 100.0,
//                      point: projected,
//                      builder: (ctx) => Container(
//                        height: 10.0,
//                        width: 10.0,
//                        color: Colors.orange,
//                      ),
//                    ),
//                  );
//                  markers = _markers;
//                  print(markers);
                });
              } else if (pointerSignal.scrollDelta.dy > 0 &&
                  mapController.zoom > 1) {
                RenderBox getBox = context.findRenderObject();
                print("$x, $y");
                var local = getBox.globalToLocal(Offset(x, y));
                print(local);
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
                  var _markers = getMarkers(model.getData(zoom), zoom, model);
//                  _markers.add(
//                    Marker(
//                      width: 100.0,
//                      height: 100.0,
//                      point: projected,
//                      builder: (ctx) => Container(
//                        height: 10.0,
//                        width: 10.0,
//                        color: Colors.orange,
//                      ),
//                    ),
//                  );
                  markers = _markers;
                });
              }
            }
          },
          child: FlutterMap( // Library that gets the map itself
            mapController: mapController,
            options: MapOptions(
              center: center,
              zoom: zoom,
              interactiveFlags: flags,
            ),
            layers: [ // Tiles of images of map in the form of a grid
              TileLayerOptions( // Tiles from a grid map; each tile is an image that rep. map
                updateInterval: 0,
                keepBuffer: 100,
                backgroundColor: Color.fromRGBO(38, 38, 38, 255),
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png", // image of tile from a specific location
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions( // Markers on the map (Ex: blue dots) IMPORTANT: This is where you make marks on the map
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
//      print(point);
//      print(element['location']);
      return Marker(
        width: 500.0,
        height: 500.0,
        point: point,
        builder: (ctx) => Container(
          child: GlobalLocationItemView(
            intensity: element['activity'],
            zoom: zoom,
            location: element['placeId'],
            mapCallback: () {
//              print(element['location']);
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
