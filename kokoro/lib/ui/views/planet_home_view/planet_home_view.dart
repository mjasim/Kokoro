import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/post/post_widget.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/planet_home_view/planet_home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PlanetHomeView extends StatelessWidget {
  const PlanetHomeView({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    double _currentSliderValue = 0.0;

    return ViewModelBuilder<PlanetHomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: TopBar(),
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    // Creating a box
                    width: 500.0,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customImageProfile(model.planetPhotoUrl, 160),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(model.name, style: TextStyle(fontSize: 22)),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text("Active Since: ${model.activeSinceDate}"),
                                Text("Population: ${model.population}"),
                                Text("Number of Posts: ${model.numPosts}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    // Creating a box
                    height: 300.0,
                    width: 500.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Creation"),
                            Container(
                              width: 380,
                              child: Slider(
                                value: model.sliderValue,
                                min: 0.0,
                                max: 100.0,
                                label: _currentSliderValue.round().toString(),
                                onChanged: (double value) {
                                  model.updateSliderValue(value);
                                  _currentSliderValue = value;
                                },
                              ),
                            ),
                            Text("Now"),
                          ],
                        ),
                        Container(
                          child: CustomPaint(
                              painter: DrawCircle(
                                  Colors.blue,
                                  _currentSliderValue,
                                  115.0,
                                  140.0
                              ),
                              child: Text("${_currentSliderValue.floor()}",
                                textAlign: TextAlign.center,
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    // Creating a box
                    width: 500.0,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        topContributorsList(model.planetPhotoUrl,
                            model.planetPhotoUrl,
                            model.planetPhotoUrl, 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.posts.length,
                        itemBuilder: (_context, index) => PostWidget(
                          post: model.posts[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => PlanetHomeViewModel(),
      onDispose: (model) => model.disposeVideoControllers(),
      onModelReady: (model) => model.init(uid),
    );
  }
}

class DrawCircle extends CustomPainter {
  Paint _paint;
  double radius;
  double dx;
  double dy;

  DrawCircle(Color color, double inputRadius, double inputX, double inputY) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
    radius = inputRadius;
    dx = inputX;
    dy = inputY;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(dx, dy), radius, _paint);

    var horizontalBaseLine = Paint();
    horizontalBaseLine.color = Colors.amber;
    horizontalBaseLine.strokeWidth = 3;
    canvas.drawLine(
      Offset(dx, dy),
      Offset(dx-250, dy),
      horizontalBaseLine,
    );

    var verticalBaseLine = Paint();
    verticalBaseLine.color = Colors.amber;
    verticalBaseLine.strokeWidth = 3;
    canvas.drawLine(
      Offset(dx-250, dy),
      Offset(dx-250, dy-100),
      verticalBaseLine,
    );

    var topRadiusLine = Paint();
    topRadiusLine.color = Colors.red;
    topRadiusLine.strokeWidth = 3;
    canvas.drawLine(
      Offset(dx, dy-radius),
      Offset(dx-250, dy-radius),
      topRadiusLine,
    );

    var topRadiusPoint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10;
    //list of points
    var points = [Offset(dx, dy-radius)];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, topRadiusPoint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class customImageProfile extends StatelessWidget {
  final String profileUrl;
  final double size;

  customImageProfile(this.profileUrl, this.size);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(80.0),
        topRight: Radius.circular(80.0),
        bottomLeft: Radius.circular(80.0),
        bottomRight: Radius.circular(80.0),
      ),
      child: (profileUrl != null || profileUrl != "") ? Image.network(
        profileUrl,
        width: size,
        height: size,
        fit: BoxFit.fill,
      ) :
      Icon(Icons.account_circle, size: size),
    );
  }
}

class topContributorsList extends StatelessWidget {
  final String profileUrl1;
  final String profileUrl2;
  final String profileUrl3;
  final double size;

  topContributorsList(this.profileUrl1, this.profileUrl2, this.profileUrl3,
      this.size);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Top Contributors"),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            customImageProfile(profileUrl1, size),
            SizedBox(width: 10.0),
            customImageProfile(profileUrl2, size),
            SizedBox(width: 10.0),
            customImageProfile(profileUrl3, size),
          ],
        ),
      ],
    );
  }
}