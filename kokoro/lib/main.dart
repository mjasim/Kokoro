import 'package:flutter/material.dart';
import 'package:kokoro/core/routes/locations.dart';
import 'package:kokoro/ui/shared/top_bar.dart';
import 'package:beamer/beamer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<BeamLocation> beamLocations = [
    GlobalViewLocation(),
    MakePostLocation(),
  ];

  final _beamerKey = GlobalKey<BeamerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: TopBar(
          beamerKey: _beamerKey,
          toolbarHeight: 60.0,
          backgroundColor: Colors.orange,
        ),
        body: Beamer(
          key: _beamerKey,
          routerDelegate:
              BeamerRouterDelegate(initialLocation: GlobalViewLocation()),
          routeInformationParser: BeamerRouteInformationParser(
            beamLocations: beamLocations,
          ),
        ),
      ),
    );
  }
}
