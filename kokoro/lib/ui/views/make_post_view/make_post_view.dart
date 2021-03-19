import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/make_post_view/make_post_viewmodel.dart';
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
        backgroundColor: Color(0xFF192841),
        appBar: TopBar(),
        body: Column(
          children: [
            Center(
              child: Container(
                // Type in Post
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                width: 500,
                height: 500,
                child: TextField(
                  controller: _postTextController,
                  minLines: 50,
                  maxLines: 100,
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                  decoration: InputDecoration(
                    hintText: "Post Text",
                    hintStyle: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 17.0),
                    fillColor: Color(0xFF192841),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Color(0xFF969696), style: BorderStyle.solid, width: 3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Color(0xFFb3b3b3), style: BorderStyle.solid, width: 4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.blue,
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1.7,
                  heightFactor: 1.2,
                  child: Text('Submit',
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
                }
            ),
          ],
        ),
      ),
      viewModelBuilder: () => MakePostViewModel(),
    );
  }
}
