import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';

class MakePostView extends StatefulWidget {
  @override
  _MakePostViewState createState() => _MakePostViewState();
}

class _MakePostViewState extends State<MakePostView> {
  @override
  Widget build(BuildContext context) {
    print('Make Post View');
    return Scaffold(
      appBar: TopBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        height: 30.0,
        width: 30.0,
        color: Colors.blueGrey,
      )
    );
  }
}
