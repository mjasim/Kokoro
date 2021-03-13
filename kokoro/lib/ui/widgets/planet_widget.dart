import 'package:flutter/material.dart';
import 'package:kokoro/ui/views/planet_view/planet_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PlanetWidget extends ViewModelWidget<PlanetViewModel> {
  PlanetWidget({this.index});

  final int index;

  @override
  Widget build(BuildContext context, PlanetViewModel model) {
    return AnimatedPositioned(
      top: model.getPlanetTop(index),
      left: model.getPlanetLeft(index),
      duration: Duration(milliseconds: 200),
      child: MouseRegion(
        onEnter: (details) {
          model.planetHover(index);
        },
        onExit: (details) {
          model.planetHoverOver(index);
        },
        child: Listener(
          onPointerDown: (details) {
            model.planetClicked(index);
          },
          child: AnimatedContainer(
            width: model.getSize(index) + 40,
            height: model.getSize(index) + 40,
            duration: Duration(milliseconds: 200),
            child: Column(
              children: [
                Container(
                  width: model.getSize(index),
                  height: model.getSize(index),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(model.getPlanetImageUrl(index))),
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                ),
                Text(
                  model.getPlanetName(index),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                )
              ],
            ),

          ),
        ),
      ),
    );
  }
}
