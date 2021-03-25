import 'package:flutter/material.dart';
import 'package:kokoro/core/models/post_model.dart';
import 'package:kokoro/ui/views/home_view/home_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends ViewModelWidget<HomeViewModel> {
  PostWidget({this.index});

  final index;
  VideoPlayerController controller;

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    PostModel post = model.posts[index];
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: Container(
        constraints:
            BoxConstraints(maxWidth: 800.0, minWidth: 100.0, minHeight: 230.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).indicatorColor,
            width: 2,
          ),
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 0.5,
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width < 700 ? 50.0 : 80.0,
                  backgroundColor: Theme.of(context).indicatorColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                      bottomLeft: Radius.circular(80.0),
                      bottomRight: Radius.circular(80.0),
                    ),
                    child: Image.network(
                      post.authorProfilePhotoUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(post.authorUsername)
              ],
            ),
            Column(
              children: [
                    Container(
                      width: MediaQuery.of(context).size.width < 700 ? 300.0 : 500.0,
//                    widthFactor: .7,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            WidgetSpan(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: model.photoUrl(index) != null
                                    ? Image.network(
                                        model.photoUrl(index),
                                      )
                                    : Container(),
                              ),
                            ),
                            WidgetSpan(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: model.hasVideo(index)
                                    ? Container(
                                        child: AspectRatio(
                                          aspectRatio: model
                                              .getController(index)
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(
                                              model.getController(index)),
                                        ),
                                      )
                                    : Container(),
                              ),
                            ),
                            TextSpan(
                              text: post.postText,
                            )
                          ],
                        ),
                      ),
                    ),
                Divider(
                  color: Theme.of(context).indicatorColor,
                  height: 2.0,
                  thickness: 2.0,
                  indent: 20,
                  endIndent: 20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.thumb_down),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Theme.of(context).indicatorColor,
                          inactiveTrackColor: Theme.of(context).indicatorColor,
                        ),
                        child: Slider(
                            value: post.userReactionAmount,
                            max: 100,
                            min: 0,
                            onChanged: (details) {
                              model.updateUserSliderReaction(index, details);
                            }),
                      ),

                      Icon(Icons.thumb_up),
                      SizedBox(
                        width: 10,
                      ),
                      Text("${post.reactionCount}"),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.comment),
                      SizedBox(
                        width: 10,
                      ),
                      Text("${post.commentCount}"),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.circle,
                        color: Color(int.parse(
                            post.reactionColor.replaceAll('#', '0xff'))),
                      ),
                      SizedBox(
                        width: 10,
                      ),
//                              Text("${post.dateCreated}"), // Something to fix for later
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
