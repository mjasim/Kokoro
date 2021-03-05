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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GlobalMapViewModel>.reactive(
      builder: (context, model, child) => Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            if (pointerSignal.scrollDelta.dy < 0 && 15 > mapController.zoom) {
              setState(() {
                zoom = mapController.zoom;
                markers = getMarkers(zoom);
              });
              print('Zoom: ${zoom}');
              mapController.move(mapController.center, mapController.zoom + 1);
            } else if (pointerSignal.scrollDelta.dy > 0) {
              setState(() {
                zoom = mapController.zoom;
                markers = getMarkers(zoom);
              });
              print('Zoom: ${zoom}');
              print((16.0 - zoom) / 15);
              mapController.move(mapController.center, mapController.zoom - 1);
            }
          }
        },
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(51.5, -0.09),
            zoom: 1.0,
            interactiveFlags: flags,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c']),
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
    if (zoom <= 7) {
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
