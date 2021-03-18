import 'package:flutter/material.dart';
import 'package:kokoro/ui/views/personal_view/personal_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PersonalView extends StatelessWidget {
    const PersonalView({Key key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
        return ViewModelBuilder<PersonalViewModel>.reactive(
            builder: (context, model, child) => Scaffold(),
            viewModelBuilder: () => PersonalViewModel(),
        );
    }
}