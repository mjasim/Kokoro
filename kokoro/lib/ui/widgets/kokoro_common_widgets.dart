import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class KokoroButton extends StatelessWidget {
  KokoroButton({this.onPressed, this.text, this.outlined: false});

  final onPressed;
  final text;
  final outlined;

  @override
  Widget build(BuildContext context) {
    return outlined
        ? OutlinedButton(
            onPressed: () => onPressed(),
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1.7,
              heightFactor: 1.2,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).indicatorColor,
                  fontSize: 17.0,
                  height: 1.7,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              side:
                  BorderSide(width: 2, color: Theme.of(context).indicatorColor),
            ),
          )
        : MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Theme.of(context).indicatorColor,
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1.7,
              heightFactor: 1.2,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  height: 1.7,
                ),
              ),
            ),
            onPressed: () {
              onPressed();
            },
          );
  }
}


class KokoroDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      color: Theme.of(context).indicatorColor,
      height: 3.0,
    );
  }
}
