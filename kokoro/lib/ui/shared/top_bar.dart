import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  TopBar({
    this.actions,
    this.backgroundColor,
    this.toolbarHeight,
    this.bottom,
  }) : preferredSize = Size.fromHeight(toolbarHeight ??
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  final Size preferredSize;

  final double? toolbarHeight;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.toolbarHeight,
      color: widget.backgroundColor,
      child: Center(
        child: Row(
          children: widget.actions ?? widget.actions!,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
