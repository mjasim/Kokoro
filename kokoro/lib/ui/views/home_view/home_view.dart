import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/home_view/home_viewmodel.dart';
import 'package:kokoro/ui/widgets/post_widget.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: TopBar(),
        body: ListView.builder(
          itemCount: model.posts.length,
          itemBuilder: (_context, index) => PostWidget(
            index: index,
          )
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
      onDispose: (model) => model.disposeVideoControllers(),
      onModelReady: (model) => model.getPosts(),
    );
  }
}
