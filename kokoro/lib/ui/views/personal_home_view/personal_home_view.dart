import 'package:flutter/material.dart';
import 'package:kokoro/ui/smart_widgets/post/post_widget.dart';
import 'package:kokoro/ui/smart_widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:kokoro/ui/views/personal_home_view/personal_home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PersonalHomeView extends StatelessWidget {
  const PersonalHomeView({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day);

    print(dateToday);
    String valueInTime =
        dateToday.year.toString() + "-" +
        dateToday.month.toString() + "-" +
        dateToday.day.toString();
    double _currentSliderValue = dateToday.millisecondsSinceEpoch.toDouble();
    double dateTodayDoubleVal = _currentSliderValue;
    DateTime dtValue = dateToday;

    return ViewModelBuilder<PersonalHomeViewModel>.reactive(
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
                              customImageProfile(model.profileUserPhotoUrl, 160),
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
                                Text("Location: ${model.location}"),
                                Text("Active Since: " +
                                    "${model.activeSinceDate.year.toString()}-"+
                                    "${model.activeSinceDate.month.toString()}-"+
                                    "${model.activeSinceDate.day.toString()}"),
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
                    height: 140.0,
                    width: 500.0,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white70,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("About me", style: TextStyle(fontSize: 22)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.aboutMe),
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
                        recentInterestsList(model.profileUserPhotoUrl,
                            model.profileUserPhotoUrl,
                            model.profileUserPhotoUrl, 100),
                        SizedBox(
                          height: 10.0,
                        ),
                        recentConnectionsList(model.profileUserPhotoUrl,
                            model.profileUserPhotoUrl,
                            model.profileUserPhotoUrl, 100),
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
                    Row( // TODO: Get Slider to work!
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Big Bang"),
                        Container(
                          width: 550,
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(valueInTime.toString(), style: TextStyle(fontSize: 12)),
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
      viewModelBuilder: () => PersonalHomeViewModel(),
      onDispose: (model) => model.disposeVideoControllers(),
      onModelReady: (model) => model.init(uid),
    );
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
      child: profileUrl != null ? Image.network(
        profileUrl,
        width: size,
        height: size,
        fit: BoxFit.fill,
      ) :
      Icon(Icons.account_circle, size: size),
    );
  }
}

class recentConnectionsList extends StatelessWidget {
  final String profileUrl1;
  final String profileUrl2;
  final String profileUrl3;
  final double size;

  recentConnectionsList(this.profileUrl1, this.profileUrl2, this.profileUrl3,
                        this.size);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Connections"),
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

class recentInterestsList extends StatelessWidget {
  final String profileUrl1;
  final String profileUrl2;
  final String profileUrl3;
  final double size;

  recentInterestsList(this.profileUrl1, this.profileUrl2, this.profileUrl3,
                      this.size);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Interests"),
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