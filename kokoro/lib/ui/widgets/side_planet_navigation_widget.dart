import 'package:flutter/material.dart';
import 'package:kokoro/ui/views/global_view/global_viewmodel.dart';
import 'package:kokoro/ui/views/planet_view/planet_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SidePlanetNavigation extends ViewModelWidget<PlanetViewModel>  {

  final List<IconData> actions = [Icons.link, Icons.group_work];

  @override
  Widget build(BuildContext context, PlanetViewModel model) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.group_work,
            color: Colors.blue,
            size: 44.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onTap: () {
            model.goToPlanetHomeViewModel();
          },
        ),
      ],
    );
  }
}