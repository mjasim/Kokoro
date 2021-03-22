import 'package:flutter/material.dart';
import 'package:kokoro/core/models/post_model.dart';
import 'package:kokoro/ui/views/home_view/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PostWidget extends ViewModelWidget<HomeViewModel> {
  PostWidget({this.index});

  final index;

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    PostModel post = model.posts[index];
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(50.0),
      child: Container(
        constraints:
            BoxConstraints(maxWidth: 800.0, minWidth: 100.0, minHeight: 400.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 8,
          ),
          color: Colors.black,
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
                  radius: 80,
                  backgroundColor: Colors.blue,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                      bottomLeft: Radius.circular(80.0),
                      bottomRight: Radius.circular(80.0),
                    ),
                    child: Image.network(post.authorProfilePhotoUrl, width: 150, height: 150, fit: BoxFit.fill,),
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
                    Text(post.postText),
                    Divider(),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.thumb_down),
                            Slider(
                                value: post.userReactionAmount,
                                max: 100,
                                min: 0,
                                onChanged: (details) {
                                  model.updateUserSliderReaction(index, details);
                                }),
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
                        )
                    ),
                  ],
                )

          ],
        ),
      ),
    );
  }
}
