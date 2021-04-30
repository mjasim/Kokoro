import 'dart:math';

import 'package:stacked/stacked.dart';

class PlanetDrillDownViewModel extends BaseViewModel {
  Map drillDownData = {};

  Map getTestData() {
    List<Map> data = [];
    Map basicUnit(name) {
      return {
        "name": name,
        "size": 1,
        "link": "http://www.google.com",
      };
    }

    List<String> names = ['John', 'Bob', 'Lucy', 'Jenny'];
    final random = Random();

    for (String name in names) {
      List<Map> children = [
        {
          "name": "Photos",
          "children": [],
        },
        {
          "name": "Videos",
          "children": [],
        },
        {
          "name": "Text",
          "children": [],
        }
      ];
      for (int j = 0; j < 3; j++) {
        if (j == 0) {
          for (int k = 0; k < random.nextInt(10); k++) {
            children[0]['children'].add(basicUnit("PIC $k"));
          }
        } else if (j == 1) {
          for (int k = 0; k < random.nextInt(10); k++) {
            children[1]['children'].add(basicUnit("VID $k"));
          }
        } else if (j == 2) {
          for (int k = 0; k < random.nextInt(10); k++) {
            children[2]['children'].add(basicUnit("TEXT $k"));
          }
        }
      }
      data.add({
        "id": name.toLowerCase(),
        "name": name,
        "img":
            "https://images.generated.photos/Co_dgV-4Fusp2NjQFaQKvY_NQDmo8HZjyyqbMpbbEog/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzAzNTcxMjYuanBn.jpg",
        "children": children,
      });
    }
    return {
      "name": "variants",
      "children": data,
    };
  }

  void init() {
    drillDownData = getTestData();
    print('TestDAta: ${drillDownData}');
  }
}
