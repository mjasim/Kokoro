import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/global_location_item/global_location_item_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class GlobalLocationItemView extends StatelessWidget {
  const GlobalLocationItemView(
      {Key key,
        this.intensity, this.zoom, this.location,
        this.mapCallback, this.hueColor})
      : super(key: key);

  final double intensity;
  final double zoom;
  final String location;
  final Function mapCallback;
  final double hueColor;

  @override
  Widget build(BuildContext context) {
//    print('In location zoom: ${zoom} ${(1 - ((16.0 - zoom) / 15)) * 300.0}');
    return ViewModelBuilder<GlobalLocationItemViewModel>.reactive(
      builder: (context, model, child) {
        if (zoom < 5 && model.isClicked) {
          model.isClicked = false;
        }
        return !model.isClicked // Checks if point has been clicked
            ? GestureDetector( // If it hasn't show circle
                child: Center(
                  child: Container(
                    width: (1 - ((16.0 - zoom) / 15)) * 100.0, // Height and width are scaled by zoom
                    height: (1 - ((16.0 - zoom) / 15)) * 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Create circular container
                      color:
                          HSVColor.fromAHSV(1.0, hueColor, intensity, 1.0) // Sets color by intensity
                              .toColor(), // Different textures for each city
                    ),
                  ),
                ),
                onTap: () {
                  print('In item, location:${location}');
                  model.clicked(mapCallback);
                },
              )
            : Stack( // If clicked shows photos around point
                children: getChildren(model, location),
              );
      },
      viewModelBuilder: () => GlobalLocationItemViewModel()..setZoom(zoom),
    );
  }

  // This widget needs to be updated so that the actual data is pulled for a location
  // To do this call the  _databaseService.getGlobalViewData(placeId: placeId) with the placeId of this dot
  // do this in the viewmodel not the view. Just change model.getProfileData to get the real data
  // Also need to add hovering support.
  List<Widget> getChildren(model, location) {
    int n = 1;
    double alpha = 137.5;
    double c = 1.0;
    List<Widget> children = model.getProfileData(location).map<Widget>((element) {
      // The math done below is following a sunflower seed pattern
      // that determines the x, y coordinates of each profile photo
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
//          decoration: BoxDecoration(
//            shape: BoxShape.circle,
//            color: Colors.red,
//          ),
          child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(element['url'])
              // TODO: Need to be able to hover over and show profile information
              // TODO: Need to be able to click on profile and go to their personal-home-view page
          ),
        ),
      );
    }).toList();
    children.add(GestureDetector( // Adding center location dot that children surround.
      child: Center(
        child: Container(
          width: (1 - ((16.0 - zoom) / 15)) * 100.0,
          height: (1 - ((16.0 - zoom) / 15)) * 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                HSVColor.fromAHSV(1.0, 211.0, intensity, 1.0).toColor(),
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
