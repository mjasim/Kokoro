import 'package:flutter/material.dart';
import 'package:kokoro/core/models/post_model.dart';
import 'package:kokoro/ui/smart_widgets/post/post_widget_viewmodel.dart';
import 'package:kokoro/ui/widgets/comment_widget.dart';
import 'package:kokoro/ui/widgets/kokoro_common_widgets.dart';
import 'package:stacked/stacked.dart';

class PostWidget extends StatefulWidget {
  PostWidget({this.post});

  final PostModel post;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  TextEditingController _commentTextController;

  @override
  void initState() {
    super.initState();
    _commentTextController = TextEditingController();
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostWidgetModel>.reactive(
      builder: (context, model, child) {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: 800.0, minWidth: 100.0, minHeight: 230.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).indicatorColor,
                width: 2,
              ),
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 0.5,
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width < 700
                              ? 50.0
                              : 80.0,
                          backgroundColor: Theme.of(context).indicatorColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(80.0),
                              topRight: Radius.circular(80.0),
                              bottomLeft: Radius.circular(80.0),
                              bottomRight: Radius.circular(80.0),
                            ),
                            child: Image.network(
                              model.post.authorProfilePhotoUrl,
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(model.post.authorUsername)
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width < 700
                              ? 300.0
                              : 500.0,
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                WidgetSpan(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: model.photoUrl() != null
                                        ? Image.network(
                                            model.photoUrl(),
                                          )
                                        : Container(),
                                  ),
                                ),
//                              WidgetSpan(
//                                child: Container(
//                                  padding: EdgeInsets.all(10.0),
//                                  child: model.hasVideo(index)
//                                      ? Container(
//                                    child: AspectRatio(
//                                      aspectRatio: model
//                                          .getController(index)
//                                          .value
//                                          .aspectRatio,
//                                      child: VideoPlayer(
//                                          model.getController(index)),
//                                    ),
//                                  )
//                                      : Container(),
//                                ),
//                              ),
                                TextSpan(
                                  text: model.post.postText,
                                )
                              ],
                            ),
                          ),
                        ),
                        KokoroDivider(),
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
                              Stack(
                                children: [
                                  Positioned(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: 40.0,
                                    ),
                                    top: -10,
                                    left: (model.post.sliderAverage - 50) + 76,
                                  ),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor:
                                          Theme.of(context).indicatorColor,
                                      inactiveTrackColor:
                                          Theme.of(context).indicatorColor,
                                      overlayColor: Colors.transparent,
                                      thumbColor: model.userHasInteractedWithSlider ?
                                          Theme.of(context).primaryColor : Theme.of(context).indicatorColor,
                                    ),
                                    child: Slider(
                                      value: model.post.userReactionAmount,
                                      max: 100,
                                      min: 0,
                                      onChanged: (details) {
                                        model.updateUserSliderReaction(details);
                                      },
                                      onChangeEnd: (details) {
                                        model.updateUserSliderReactionFinal(details);
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              Icon(Icons.thumb_up),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${model.post.sliderReactionCount}"),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: Icon(Icons.comment),
                                onTap: () {
                                  model.toggleComments();
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${model.post.commentCount}"),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.circle,
                                color: model.post.reactionColor
                                    ,
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
                AnimatedContainer(
                  margin: EdgeInsets.only(top: 10.0),
                  height: model.post.commentsOpen
                      ? model.post.commentCount > 0
                          ? 340.0
                          : 220
                      : 0.0,
                  constraints: BoxConstraints(maxWidth: 800.0, minWidth: 100.0),
                  duration: Duration(milliseconds: 200),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        KokoroDivider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width < 700
                                    ? 30.0
                                    : 50.0,
                                backgroundColor:
                                    Theme.of(context).indicatorColor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(80.0),
                                    topRight: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0),
                                    bottomRight: Radius.circular(80.0),
                                  ),
                                  child: Image.network(
                                    model.post.authorProfilePhotoUrl,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.only(left: 30.0, top: 30.0),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 30.0, top: 30.0),
                              height: 100.0,
                              width: 600,
                              child: TextField(
                                controller: _commentTextController,
                                onChanged: (value) =>
                                    model.commentOnChange(value),
                                minLines: 20,
                                maxLines: 30,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                                decoration: InputDecoration(
                                  hintText: "Comment Text",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).indicatorColor,
                                      fontSize: 17.0),
                                  fillColor: Theme.of(context).backgroundColor,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).indicatorColor,
                                        style: BorderStyle.solid,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).focusColor,
                                        style: BorderStyle.solid,
                                        width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: KokoroButton(
                                text: 'Cancel',
                                outlined: true,
                              ),
                              margin: EdgeInsets.only(top: 10, right: 10),
                            ),
                            Container(
                              child: KokoroButton(
                                text: 'Submit',
                                onPressed: () {
                                  model.postComment();
                                  _commentTextController.clear();
                                },
                              ),
                              margin: EdgeInsets.only(top: 10, right: 30),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        KokoroDivider(),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return CommentWidget(
                              text: model.comments[index].commentText,
                              username: model.comments[index].username,
                              profilePhotoUrl: model.comments[index].authorProfilePhotoUrl,
                            );
                          },
                          shrinkWrap: true,
                          itemCount: model.comments.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => PostWidgetModel(),
      onModelReady: (model) => model.init(widget.post),
    );
  }
}
