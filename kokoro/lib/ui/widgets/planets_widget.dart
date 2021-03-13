import 'package:flutter/material.dart';
import 'package:kokoro/ui/views/planet_view/planet_viewmodel.dart';
import 'package:kokoro/ui/widgets/planet_widget.dart';
import 'package:stacked/stacked.dart';

class PlanetsWidget extends ViewModelWidget<PlanetViewModel> {
  @override
  Widget build(BuildContext context, PlanetViewModel model) {
    List<Widget> children = model.planetInfo.asMap().entries.map<Widget>((entry) {
      int index = entry.key;
      return PlanetWidget(index: index);
    }).toList();
    return Container(
//      color: Colors.black,
      child: Stack(
        children: children,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          
          image: NetworkImage("https://images.unsplash.com/photo-1542228846-2d791a09d7d1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80"),
        ),
      ),
    );
  }
}