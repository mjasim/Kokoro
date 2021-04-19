
import 'package:flutter_map/flutter_map.dart';
import 'package:kokoro/ui/views/personal_view/personal_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class PersonalMapView extends ViewModelWidget<PersonalViewModel> {
  @override
  bool get reactive => false;

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
          MarkerLayerOptions(
            markers: model.markers,
          ),
        ],
      ),
    );
  }
}