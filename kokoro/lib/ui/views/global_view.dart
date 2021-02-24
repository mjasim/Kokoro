import 'package:flutter/material.dart';
import 'package:kokoro/ui/shared/top_bar.dart';

class GlobalView extends StatefulWidget {
  final actions = [
    Icon(
      Icons.favorite,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    Icon(
      Icons.beach_access,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
  ];

  @override
  _GlobalViewState createState() => _GlobalViewState();
}

class _GlobalViewState extends State<GlobalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.orange,
        actions: widget.actions,
      ),
      body: Container(
        height: 30.0,
        width: 30.0,
        color: Colors.purple,
      ),
    );
  }
}
