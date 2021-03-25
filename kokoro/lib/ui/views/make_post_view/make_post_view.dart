import 'dart:html';

import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/make_post_view/make_post_viewmodel.dart';
import 'package:video_player/video_player.dart';

import 'package:stacked/stacked.dart';

class MakePostView extends StatefulWidget {
  @override
  _MakePostViewState createState() => _MakePostViewState();
}

class _MakePostViewState extends State<MakePostView> {
  TextEditingController _postTextController;

  void initState() {
    super.initState();
    _postTextController = TextEditingController();
  }

  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MakePostViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: TopBar(),
        body: AutoScrollWrapperWidget(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  width: 500,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Post Text',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: _postTextController,
                        minLines: 20,
                        maxLines: 30,
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                        decoration: InputDecoration(
                          hintText: "Post Text",
                          hintStyle: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 17.0),
                          fillColor: Theme.of(context).backgroundColor,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).indicatorColor,
                                style: BorderStyle.solid,
                                width: 3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor,
                                style: BorderStyle.solid,
                                width: 4),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Icon(Icons.image),
                              onTap: () {
                                model.pickImage();
                              },
                            ),
                            GestureDetector(
                              child: Icon(Icons.videocam),
                              onTap: () {
                                model.pickVideo();
                              },
                            )
                          ],
                        ),
                      ),
                      model.imageFile != null
                          ? Image.network(
                              model.imageFile.path,
                              width: 100.0,
                            )
                          : Container(),
                      model.videoFile != null
                          ? Container(
                              width: 100.0,
                              height: 100.0,
                              child: AspectRatio(
                                aspectRatio: model.controller.value.aspectRatio,
                                child: VideoPlayer(model.controller),
                              ))
                          : Container(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Theme.of(context).indicatorColor,
                          child: Align(
                            alignment: Alignment.center,
                            widthFactor: 1.7,
                            heightFactor: 1.2,
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                height: 1.7,
                              ),
                            ),
                          ),
                          onPressed: () {
                            model.makePost(_postTextController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => MakePostViewModel(),
    );
  }
}

class AutoScrollWrapperWidget extends StatelessWidget {
  AutoScrollWrapperWidget({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: child,
        ),
      );
    });
  }
}
