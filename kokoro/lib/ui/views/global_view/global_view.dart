import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/global_view/global_viewmodel.dart';
import 'package:kokoro/ui/widgets/side_navigation_widget.dart';

import 'package:stacked/stacked.dart';

class GlobalView extends StatelessWidget {
  const GlobalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Global View');
    return ViewModelBuilder<GlobalViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: TopBar(
          toolbarHeight: 60.0,
          backgroundColor: Colors.orange,
        ),
        body: Stack(
          children: [
            SideNavigation(),
            Center(
              child: Container(
                height: 30.0,
                width: 30.0,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => GlobalViewModel(),
    );
  }
}
