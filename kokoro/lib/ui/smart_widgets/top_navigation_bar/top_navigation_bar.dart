import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  TopBar({
    this.backgroundColor,
    this.toolbarHeight,
    this.bottom,
  }) : preferredSize = Size.fromHeight(toolbarHeight ??
            kToolbarHeight + (bottom.preferredSize.height ?? 0.0));

  @override
  final Size preferredSize;

  final double toolbarHeight;
  final List<IconData> actions = [Icons.public, Icons.add_box];

  final Color backgroundColor;
  final PreferredSizeWidget bottom;

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final icons = [Icons.public, Icons.add_box];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopNavigationBarViewModel>.reactive(
      builder: (context, model, child) {
        return Container(
          height: widget.toolbarHeight,
          color: widget.backgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Row(
                  children: getChildren(model),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              MaterialButton(
                child: Text('Sign out'),
                onPressed: () {
                  model.signOut();
                },
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => TopNavigationBarViewModel(),
    );
  }

  List<Widget> getChildren(TopNavigationBarViewModel model) {
    List<Widget> children = [];
    for (var i = 0; i < icons.length; i++) {
      children.add(
        GestureDetector(
          child: Icon(
            icons[i],
            color: i == model.currentIndex() ? Colors.blue : Colors.white,
            size: 44.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onTap: () {
            model.changeIndex(i);
          },
        ),
      );
    }
    return children;
  }
}
