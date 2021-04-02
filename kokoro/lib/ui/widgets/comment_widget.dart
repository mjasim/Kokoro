import 'package:flutter/material.dart';
import 'package:kokoro/ui/widgets/kokoro_common_widgets.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({this.text, this.username, this.profilePhotoUrl});

  final text;
  final username;
  final profilePhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30.0, top: 10.0),
                  child: CircleAvatar(
                    radius:
                        MediaQuery.of(context).size.width < 700 ? 25.0 : 40.0,
                    backgroundColor: Theme.of(context).indicatorColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        topRight: Radius.circular(80.0),
                        bottomLeft: Radius.circular(80.0),
                        bottomRight: Radius.circular(80.0),
                      ),
                      child: Image.network(
                        profilePhotoUrl,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30.0, top: 10.0),
                  child: Text(username),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, top: 30.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: text,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          child: KokoroDivider(),
          margin: EdgeInsets.only(top: 10.0),
        )
        ,
      ],
    ));
  }
}
