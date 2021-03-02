import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:kokoro/ui/views/global_view.dart';
import 'package:kokoro/ui/views/make_post_view.dart';
import 'package:kokoro/ui/views/planet_view.dart';


class GlobalViewLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => ['/'];

  @override
  List<BeamPage> get pages => [
    BeamPage(
      key: ValueKey('global-view'),
      child: GlobalView(),
    ),
  ];
}

class MakePostLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => ['/makepost'];

  @override
  List<BeamPage> get pages => [
    BeamPage(
      key: ValueKey('make-post-view'),
      child: MakePostView(),
    ),
  ];
}

class PlanetViewLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => ['/planets'];

  @override
  List<BeamPage> get pages => [
    BeamPage(
      key: ValueKey('planet-view'),
      child: PlanetView(),
    ),
  ];
}