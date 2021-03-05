import 'package:flutter/material.dart';

class SideNavigation extends StatefulWidget {


  final List<IconData> actions = [Icons.link, Icons.group_work];


  @override
  _SideNavigationState createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  int _currentIndex = 0;
  List<Widget> children = [];

  @override
  Widget build(BuildContext context) {
//    _updateChildren(context);
    return Column(
      children: children,
    );
  }


//  void _updateChildren(BuildContext context) {
//    children = [];
//    for (var i = 0; i < widget.locations.length; i++) {
//      children.add(
//        GestureDetector(
//          child: Icon(
//            widget.actions[i],
//            color: i == _currentIndex ? Colors.blue : Colors.black,
//            size: 44.0,
//            semanticLabel: 'Text to announce in accessibility modes',
//          ),
//          onTap: () {
//            context.beamTo(widget.locations[i]);
//          },
//        ),
////      );
//    }
//  }
}
