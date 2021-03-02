import 'package:flutter/material.dart';
import 'package:kokoro/ui/widgets/side_navigation_widget.dart';

class GlobalView extends StatefulWidget {
  @override
  _GlobalViewState createState() => _GlobalViewState();
}

class _GlobalViewState extends State<GlobalView> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SideNavigation(),
      Center(
        child: Container(
          height: 30.0,
          width: 30.0,
          color: Colors.red,
        ),
      )
    ]);
  }
}
