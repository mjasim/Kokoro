import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:kokoro/core/routes/locations.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  TopBar({
    required this.beamerKey,
    this.backgroundColor,
    this.toolbarHeight,
    this.bottom,
  }) : preferredSize = Size.fromHeight(toolbarHeight ??
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  final GlobalKey<BeamerState> beamerKey;

  @override
  final Size preferredSize;

  final double? toolbarHeight;
  final List<IconData>? actions = [Icons.public, Icons.add_box];

  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  final List<BeamLocation> locations = [
    GlobalViewLocation(),
    MakePostLocation()
  ];

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int _currentIndex = 0;
  List<Widget> children = [];

  @override
  void initState() {
    widget.beamerKey.currentState!.routerDelegate
        .addListener(() => _updateCurrentIndex());
    super.initState();
    _updateChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.toolbarHeight,
      color: widget.backgroundColor,
      child: Center(
        child: Row(
          children: children,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  void _updateCurrentIndex() {
    int index = 0;
    var currentLocation = widget.beamerKey.currentState!.currentLocation;
    if (currentLocation is GlobalViewLocation) {
      index = 0;
    } else if (currentLocation is MakePostLocation) {
      index = 1;
    }
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      _updateChildren();
    }
  }

  void _updateChildren() {
    children = [];
    for (var i = 0; i < widget.locations.length; i++) {
      children.add(
        GestureDetector(
          child: Icon(
            widget.actions![i],
            color: i == _currentIndex ? Colors.blue : Colors.white,
            size: 44.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onTap: () {
            widget.beamerKey.currentState!.routerDelegate
                .beamTo(widget.locations[i]);
          },
        ),
      );
    }
    setState(() {

    });
  }
}
