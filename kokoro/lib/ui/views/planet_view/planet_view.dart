import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/planet_view/planet_viewmodel.dart';
import 'package:kokoro/ui/widgets/planets_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:kokoro/ui/widgets/side_planet_navigation_widget.dart';

class PlanetView extends StatelessWidget {
  const PlanetView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PlanetViewModel>.reactive(
      builder: (context, model, child) {
        var scrSize = MediaQuery.of(context).size;
        model.setSize(scrSize);
        return Scaffold(
            appBar: TopBar(),
            body: Stack(
              children: [
                PlanetsWidget(),
                SidePlanetNavigation(),
              ],
            ),
        );
      },
      viewModelBuilder: () => PlanetViewModel(),
      onModelReady: (model) => model.init(),
    );
  }
}
