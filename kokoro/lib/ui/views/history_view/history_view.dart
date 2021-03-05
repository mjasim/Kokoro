import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/history_view/history_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HistoryView extends StatelessWidget {
    const HistoryView({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return ViewModelBuilder<HistoryViewModel>.reactive(
            builder: (context, model, child) => Scaffold(
              appBar: TopBar(),
              body: Center(
                child: Text(
                  'History View'
                ),
              ),
            ),
            viewModelBuilder: () => HistoryViewModel(),
        );
    }
}