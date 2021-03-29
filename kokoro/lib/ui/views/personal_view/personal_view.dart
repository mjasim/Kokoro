import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/personal_view/personal_map_view.dart';
import 'package:kokoro/ui/views/personal_view/personal_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PersonalView extends StatelessWidget {
    const PersonalView({Key key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
        return ViewModelBuilder<PersonalViewModel>.reactive(
            builder: (context, model, child) => Scaffold(
                appBar: TopBar(),
                backgroundColor: Color.fromRGBO(38,38,38,255),
                body: Stack(
                    children: [
                        PersonalMapView()
                    ],
                ),
            ),
            viewModelBuilder: () => PersonalViewModel(),
            onModelReady: (model) => model.init(),
            onDispose: (model) => model.dispose(),
        );
    }
}