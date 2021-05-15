import 'dart:math';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/core/services/firebase_storage_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:kokoro/core/services/firebase_storage_service.dart';
import 'package:video_player/video_player.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';

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

  final _nagivationService = locator<NavigationService>();

  List<Map> planetInfo = [];
  final _nagivationService = locator<NavigationService>();
  void init() {
    List<String> names = [
      'Cat',
      'Dog',
      'HCI',
      'Web Design',
      'Travel',
      'Coffee',
      'Nissan',
      'Viola',
      'Bridgerton',
      'Drones',
    ];
    planetInfo = makeMockPlanetData(names);
  }

  double scrWidth = 500;
  double scrHeight = 500;

  void setSize(size) {
    scrWidth = size.width;
    scrHeight = size.height;
  }

  List<Map> makeMockPlanetData(List<String> names) {
    List<Map> _planetInfo = [];
    var i = 1;
    // double alpha = 134.0;
    // double c = 3.0;r

    // jasim - get from screen using MediaQuery
    int width = 500;
    int height = 500;

    print(scrHeight.toString() + " " + scrWidth.toString());

    // jasim - get from width, height, and population range conversion
    int planetMinSize = 50;
    int planetMaxSize = 200;
    int protect = 10000;

    names.forEach((element) {
      // double rad = c * sqrt(i);
      // double angle = i * alpha;

      // double x = degrees(cos(radians(angle))) * rad + 500;
      // double y = degrees(sin(radians(angle))) * rad + 800;

      bool coordInserted = false;
      int cnt = 0;
      double dist = 0;
      while (coordInserted == false && cnt < protect) {
        cnt++;

        int size = Random().nextInt(200);
        while (size < planetMinSize) {
          size = Random().nextInt(200);
        }

        bool overlap = false;

        Random random = new Random();
        int xCandidate = planetMaxSize + random.nextInt(height);
        int yCandidate = planetMaxSize + random.nextInt(width);

        for (int k = 0; k < _planetInfo.length; k++) {
          dist = sqrt(pow(xCandidate - _planetInfo[k]["top"], 2) +
              pow(yCandidate - _planetInfo[k]["left"], 2));

          if (dist < ((size / 2) + (_planetInfo[k]["size"] / 2) + 50)) {
            overlap = true;
            break;
          }
        }

        if (overlap == false) {
          // print(size);
          _planetInfo.add({
            'imageUrl': 'images/circle-cropped($i).png',
            'top': xCandidate,
            'left': yCandidate,
            'size': size,
            'name': element,
          });
          i++;
          coordInserted = true;
        }
      }
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

  void planetClicked(index) {
    _nagivationService.navigateTo(Routes.planetDrillDownView);
  }

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

  void goToPlanetHomeViewModel() {
    _nagivationService.navigateTo(Routes.planetHomeView);
  }
}
