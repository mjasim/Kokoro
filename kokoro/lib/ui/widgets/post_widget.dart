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
          color: Colors.orange,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CircleAvatar(
                  child: Image.network(post.authorProfilePhotoUrl),
                ),
                Text(post.authorUsername)
              ],
            ),
            Column(
              children: [
                Text(post.postText),
                Divider(),
                Row(
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
                    Text("${post.reactionCount}"),
                    Icon(Icons.comment),
                    Text("${post.commentCount}"),
                    Icon(
                      Icons.circle,
                      color: Color(int.parse(
                          post.reactionColor.replaceAll('#', '0xff'))),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
