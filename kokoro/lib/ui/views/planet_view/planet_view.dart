import 'package:flutter/material.dart';
import 'package:kokoro/ui/widgets/side_navigation_widget.dart';

class PlanetView extends StatefulWidget {
  @override
  _PlanetViewState createState() => _PlanetViewState();
}

class _PlanetViewState extends State<PlanetView> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SideNavigation(),
      Center(
        child: Text(
          'Planet View',
        ),
      )
    ]);
  }
}
