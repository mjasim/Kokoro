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
  Color userSelectedColor;
  double userReactionAmount;
  int commentCount;
  bool commentsOpen;

  double sliderAverage;
  Color reactionColor;

  void updateSliderAverage({userSliderChange: 0, sliderCountChange: 0}) {
    sliderAverage = sumOfSliderReactions / sliderReactionCount;
  }

  void updateReactColorAverage({userHueChange: 0, userSaturationChange: 0, userLightnessChange: 0, userAlphaChange: 0, colorCountChange: 0}) {
    double avgHue = 360;
    double avgSat = 0;
    double avgValue = 360;
    if (colorReactionCount > 0) {
      avgHue = (sumOfHueColorValue + userHueChange) / (colorReactionCount + colorCountChange);
      avgSat = (sumOfSaturationColorValue + userSaturationChange) / (colorReactionCount + colorCountChange);
      avgValue = (sumOfLightnessColorValue + userLightnessChange) / (colorReactionCount + colorCountChange);
    }

    print(avgValue);
    print(avgSat);
    print(avgHue);
    reactionColor = HSVColor.fromAHSV(1.0, avgHue, avgSat, avgValue / 360).toColor();
  }

  void updateUserReactColor(Map data) {
    double hue = 360;
    double saturation = 0;
    double value = 360;


    if (data != null) {
      hue = data['hue'];
      saturation = data['saturation'];
      value = data['lightness'];
    }
    userSelectedColor = HSVColor.fromAHSV(1.0, hue, saturation, value / 360).toColor();
  }
}
