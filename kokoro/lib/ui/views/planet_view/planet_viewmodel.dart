import 'dart:math';

import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class PlanetViewModel extends BaseViewModel {
//  List<Map> planetInfo = [
//    {
//      'imageUrl': 'images/circle-cropped(1).png',
//      'top': 50.0,
//      'left': 50.0,
//      'size': 50.0,
//      'name': 'Cats',
//    },
//  ];
  List<Map> planetInfo = [];
  void init() {
    List<String> names = ['Cat', 'Dog', 'HCI', 'Web Design', 'Travel', 'Coffee', 'Nissan', 'Viola', 'Bridgerton', 'Drones'];
    planetInfo = makeMockPlanetData(names);
  }


  List<Map> makeMockPlanetData(List<String> names) {
    List<Map> _planetInfo = [];
    var i = 1;
    double alpha = 134.0;
    double c = 3.0;
    names.forEach((element) {
      double rad = c * sqrt(i);
      double angle = i * alpha;

      double x = degrees(cos(radians(angle))) * rad + 500;
      double y = degrees(sin(radians(angle))) * rad + 800;

      int size = Random().nextInt(250);
      while(size < 50) {
        size = Random().nextInt(250);
      }

      _planetInfo.add({
        'imageUrl': 'images/circle-cropped($i).png',
        'top': x,
        'left': y,
        'size': size,
        'name': element,
      });
      i++;
    });
    return _planetInfo;
  }

  void planetHover(index) {
    planetInfo[index]['size'] = planetInfo[index]['size'] + 5;
    planetInfo[index]['top'] = planetInfo[index]['top'] - 2.5;
    planetInfo[index]['top'] = planetInfo[index]['top'] - 2.5;
    notifyListeners();
  }

  void planetHoverOver(index) {
    planetInfo[index]['size'] = planetInfo[index]['size'] - 5;
    planetInfo[index]['top'] = planetInfo[index]['top'] + 2.5;
    planetInfo[index]['top'] = planetInfo[index]['top'] + 2.5;
    notifyListeners();
  }

  void planetClicked(index) {}

  String getPlanetName(index) {
    return planetInfo[index]['name'];
  }

  String getPlanetImageUrl(index) {
    return planetInfo[index]['imageUrl'];
  }

  double getPlanetLeft(index) {
    return planetInfo[index]['left'];
  }

  double getPlanetTop(index) {
    return planetInfo[index]['top'];
  }

  double getSize(index) {
    return planetInfo[index]['size'];
  }
}
