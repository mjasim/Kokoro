import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/global_location_item/global_location_item_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class GlobalLocationItemView extends StatelessWidget {
  const GlobalLocationItemView({Key key, this.intensity, this.zoom, this.location, this.mapCallback})
      : super(key: key);

  final double intensity;
  final double zoom;
  final String location;
  final Function mapCallback;

  @override
  Widget build(BuildContext context) {
//    print('In location zoom: ${zoom} ${(1 - ((16.0 - zoom) / 15)) * 300.0}');
    return ViewModelBuilder<GlobalLocationItemViewModel>.reactive(
      builder: (context, model, child) {
        if (zoom < 5 && model.isClicked) {
          model.isClicked = false;
        }
        return !model.isClicked
            ? GestureDetector(
                child: Center(
                  child: Container(
                    width: (1 - ((16.0 - zoom) / 15)) * 100.0,
                    height: (1 - ((16.0 - zoom) / 15)) * 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          HSVColor.fromAHSV(1.0, 211.0, intensity / 100.0, 1.0)
                              .toColor(),
                    ),
                  ),
                ),
                onTap: () {
                  print('In item, location:${location}');
                  model.clicked(mapCallback);

                },
              )
            : Stack(
                children: getChildren(model, location),
              );
      },
      viewModelBuilder: () => GlobalLocationItemViewModel()..setZoom(zoom),
    );
  }

  List<Widget> getChildren(model, location) {
    int n = 1;
    double alpha = 137.5;
    double c = 1.0;
    List<Widget> children = model.getProfileData(location).map<Widget>((element) {
      double rad = c * sqrt(n);
      double angle = n * alpha;

      double x = degrees(cos(radians(angle))) * rad + 260;
      double y = degrees(sin(radians(angle))) * rad + 320;

      n++;
      return Positioned(
        top: (((16.0 - zoom) / 15)) * y,
        left: (((16.0 - zoom) / 15)) * x,
        child: Container(
          width: (1 - ((16.0 - zoom) / 15)) * 200.0,
          height: (1 - ((16.0 - zoom) / 15)) * 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(element['url'])
          ),
        ),
      );
    }).toList();
    children.add(GestureDetector(
      child: Center(
        child: Container(
          width: (1 - ((16.0 - zoom) / 15)) * 100.0,
          height: (1 - ((16.0 - zoom) / 15)) * 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                HSVColor.fromAHSV(1.0, 211.0, intensity / 100.0, 1.0).toColor(),
          ),
        ),
      ),
      onTap: () {
        print('In item, location:${location}');
        model.clicked(mapCallback);
      },
    ));
    return children;
  }
}
