import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/personal_location_item/personal_location_item_viewmodel.dart';
import 'package:kokoro/ui/views/personal_view/personal_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class PersonalLocationItemView extends ViewModelWidget<PersonalViewModel>  {
  const PersonalLocationItemView({Key key,
    this.intensity, this.zoom, this.location,
    this.mapCallback, this.hasClickedOnLine, this.hueColor, this.placeId})
      : super(key: key);

  final double intensity;
  final double zoom;
  final String location;
  final Function mapCallback;
  final bool hasClickedOnLine; // "Boolean" parameter to identify clicking a dot vs. line
  final double hueColor; // Color of point on map
  final String placeId; // PlaceId of a certain location item

  @override
  Widget build(BuildContext context, PersonalViewModel model) {
        if (zoom < 5 && model.isClicked) {
          model.isClicked = false;
        }
        print("model.clickedPlaceId: ${model.clickedPlaceId}");
        print("location:             ${location}");
        return (model.clickedPlaceId != location) // Checks if point has been clicked
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
                onTap: () async {
                  print('On tap of personal_location_item_view, location: ${location}');
                  model.clicked(mapCallback);
                  print('Point has been clicked');
                  await model.getListOfProfileUrls(location);
                  print('List of Profile Urls at ${location} has been collected');
                  model.pointClicked(location);
                  print('Profile Urls: ${model.profileUrlData}');
                },
              )
            :
            Container(
              height: 200,
              width: 200,
              child: Stack( // If clicked shows photos around point
                children: getChildren(model, location),
              ),
            );
  }

  // This widget needs to be updated so that the actual data is pulled for a location
  // To do this call the  _databaseService.getGlobalViewData(placeId: placeId) with the placeId of this dot
  // do this in the viewmodel not the view. Just change model.getProfileData to get the real data
  // Also need to add hovering support.
  List<Widget> getChildren(PersonalViewModel model, location) {
    int n = 1;
    double alpha = 137.5;
    double c = 1.0;
    dynamic profileChildrenList = model.profileUrlData;

    print("model.profileUrlData: ${profileChildrenList}");

    List<Widget> children = profileChildrenList.map<Widget>((element) {
      // The math done below is following a sunflower seed pattern
      // that determines the x, y coordinates of each profile photo
      double rad = c * sqrt(n);
      double angle = n * alpha;

      double x = degrees(cos(radians(angle))) * rad + 260;
      double y = degrees(sin(radians(angle))) * rad + 320;

      n++;

      int divisor = 10000;

      print("In getChildren() of personal map, top-position : ${((((16.0 - zoom))) * y)/divisor}");
      print("In getChildren() of personal map, left-position: ${((((16.0 - zoom))) * x)/divisor}");
      return Positioned(
        top: ((((16.0 - zoom))) * y)/divisor,
        left: ((((16.0 - zoom))) * x)/divisor,
        child: Container(
          width: (1 - ((16.0 - zoom) / 15)) * 170.0,
          height: (1 - ((16.0 - zoom) / 15)) * 170.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  element != null ?
                  element :
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg/440px-Ash_Tree_-_geograph.org.uk_-_590710.jpg",
              )
              // TODO: Need to be able to hover over and show profile information
              // TODO: Need to be able to click on profile and go to their personal-home-view page

          ),
        ),
      );
    }).toList();

    print('children list: ${children}'); // TODO: Empty; need to find out how to add positions

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
        print('In item, location: ${location}');
        model.clicked(mapCallback);
      },
    ));
    return children;
  }
}
