import 'package:flutter/material.dart';

class PostModel {
  PostModel({
    this.authorUid,
    this.authorProfilePhotoUrl,
    this.authorUsername,
    this.dateCreated,
    this.postText,
    this.contentType,
    this.contentUrl,
    this.colorReactionCount,
    this.userReactionAmount,
    this.userSelectedColor,
    this.commentCount,
    this.commentsOpen,
    this.postUid,
    this.planets,
    this.sliderReactionCount,
    this.sumOfHueColorValue,
    this.sumOfLightnessColorValue,
    this.sumOfSaturationColorValue,
    this.sumOfSliderReactions
  }) {
    print('here');
    updateSliderAverage();
    updateReactColorAverage();
  }

  final authorUid;
  final authorUsername;
  final authorProfilePhotoUrl;
  final dateCreated;
  final postText;
  final contentType;
  final contentUrl;
  final postUid;
  int colorReactionCount;
  int sumOfHueColorValue;
  int sumOfSaturationColorValue;
  int sumOfLightnessColorValue;
  double sumOfSliderReactions;
  int sliderReactionCount;
  List<dynamic> planets;
  String userSelectedColor;
  double userReactionAmount;
  int commentCount;
  bool commentsOpen;

  double sliderAverage;
  Color reactionColor;

  void updateSliderAverage({userSliderChange: 0, sliderCountChange: 0}) {
    sliderAverage = sumOfSliderReactions / sliderReactionCount;
  }

  void updateReactColorAverage() {
    double avgHue = 360;
    double avgSat = 0;
    double avgValue = 360;
    if (colorReactionCount > 0) {
      avgHue = sumOfHueColorValue / colorReactionCount;
      avgSat = sumOfSaturationColorValue / colorReactionCount;
      avgValue = sumOfLightnessColorValue / colorReactionCount;
    }

    print(avgValue);
    print(avgSat);
    print(avgHue);
//    reactionColor = HSVColor.fromAHSV(1.0, avgHue, avgSat, avgValue).toColor();
  }
}
