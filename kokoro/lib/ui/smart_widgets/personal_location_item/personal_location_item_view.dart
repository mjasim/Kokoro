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
    List<Widget> children = profileChildrenList.map<Widget>((element) {
      // The math done below is following a sunflower seed pattern
      // that determines the x, y coordinates of each profile photo
      double rad = c * sqrt(n);
      double angle = n * alpha;

      double x = degrees(cos(radians(angle))) * rad + 260;
      double y = degrees(sin(radians(angle))) * rad + 320;

      n++;

      print("In getChildren() of personal map, top-position : ${(((16.0 - zoom) / 15)) * y}");
      print("In getChildren() of personal map, left-position: ${(((16.0 - zoom) / 15)) * x}");
      return Positioned(
        top: ((((16.0 - zoom) / 15)) * y)/10,
        left: ((((16.0 - zoom) / 15)) * x)/10,
        child: Container(
          width: (1 - ((16.0 - zoom) / 15)) * 200.0,
          height: (1 - ((16.0 - zoom) / 15)) * 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: CircleAvatar(
//              radius: 20,
//              child: ClipRRect(
//                borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(80.0),
//                topRight: Radius.circular(80.0),
//                bottomLeft: Radius.circular(80.0),
//                bottomRight: Radius.circular(80.0),
//              ),
//              child: Image.network(
//                element != null ?
//                  element :
//                  "data:image/jpeg;base64,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",
//                width: 150,
//                height: 150,
//                fit: BoxFit.fill,
//              ),
//            ),
//
//
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
