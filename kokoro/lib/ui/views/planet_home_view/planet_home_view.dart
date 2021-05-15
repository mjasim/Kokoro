import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:kokoro/ui/smart_widgets/post/post_widget.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/planet_home_view/planet_home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PlanetHomeView extends StatelessWidget {
  const PlanetHomeView({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {

    DateTime dateToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day);

    print(dateToday);
    String valueInTime = "";
    double _currentSliderValue = dateToday.millisecondsSinceEpoch.toDouble();
    double dateTodayDoubleVal = _currentSliderValue;
    DateTime dtValue = dateToday;
    print(_currentSliderValue);

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
                                Text("Active Since: " +
                                    "${model.activeSinceDate.year.toString()}-"+
                                    "${model.activeSinceDate.month.toString()}-"+
                                    "${model.activeSinceDate.day.toString()}"),
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
                                min: model.activeSinceDate.millisecondsSinceEpoch.toDouble(),
                                max: dateToday.millisecondsSinceEpoch.toDouble(),

                                label: valueInTime,
                                onChanged: (double value) {
                                  dtValue = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                                  valueInTime = dtValue.year.toString() + '-' + dtValue.month.toString() + '-' + dtValue.day.toString();

                                  model.updateSliderValue(dtValue.millisecondsSinceEpoch.toDouble());
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
                                  model.activeSinceDate.millisecondsSinceEpoch.toDouble(),
                                  dateTodayDoubleVal,
                                  _currentSliderValue,
                                  dtValue,
                                  115.0,
                                  140.0
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
  double circleMax = 100;
  double circleMin = 0;
  double dateMax;
  double dateMin;
  double sliderDate;
  DateTime printDate;
  double dx;
  double dy;
  double outputRadius;

  DrawCircle(Color color, double inputDateMin, double inputDateMax, double inputDate, DateTime date, double inputX, double inputY) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
    dateMax = inputDateMax;
    dateMin = inputDateMin;
    sliderDate = inputDate;
    printDate = date;
    dx = inputX;
    dy = inputY;

    double percent = (sliderDate - dateMin) / (dateMax - dateMin);
    outputRadius = percent * (circleMax - circleMin) + circleMin;
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(dx, dy), outputRadius, _paint);

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
      Offset(dx, dy-outputRadius),
      Offset(dx-250, dy-outputRadius),
      topRadiusLine,
    );

    var topRadiusPoint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10;
    //list of points
    var points = [Offset(dx, dy-outputRadius)];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, topRadiusPoint);

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    final textSpan = TextSpan(
      text: "${printDate.year.toString()}-"+
            "${printDate.month.toString()}-"+
            "${printDate.day.toString()}",
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 80,
    );
    final offset = Offset(dx-240, dy-outputRadius-20);
    textPainter.paint(canvas, offset);
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
      child: (profileUrl != null) ? Image.network(
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