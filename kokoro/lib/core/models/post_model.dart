import 'package:flutter/material.dart';

class PostModel {
  PostModel(
      {this.authorUid,
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
      this.sumOfSliderReactions,}) {
    updateSliderAverage();
    updateReactColorAverage();
    updateUserReactColor();
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
  double sumOfHueColorValue;
  double sumOfSaturationColorValue;
  double sumOfLightnessColorValue;
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
//    print('sliderAverage $sliderAverage, type ${sliderAverage.runtimeType}, ${sliderAverage.isNaN}');
    if (sliderAverage.isNaN) {
      sliderAverage = 50;
    }
//    print('sliderAverage $sliderAverage');
  }

  void updateReactColorAverage({
    userHueChange: 0,
    userSaturationChange: 0,
    userLightnessChange: 0,
    userAlphaChange: 0,
    colorCountChange: 0,
  }) {
    double avgHue = 360;
    double avgSat = 0;
    double avgValue = 1;
    if (colorReactionCount > 0) {
      sumOfHueColorValue -= userHueChange;
      sumOfSaturationColorValue -= userSaturationChange;
      sumOfLightnessColorValue -= userLightnessChange;
      avgHue = (sumOfHueColorValue ) /
          (colorReactionCount + colorCountChange);
      avgSat = (sumOfSaturationColorValue) /
          (colorReactionCount + colorCountChange);
      avgValue = (sumOfLightnessColorValue) /
          (colorReactionCount + colorCountChange);
    }

    avgHue = avgHue != null ? avgHue : 1;
    avgSat = avgSat != null ? avgSat : 1;
    avgValue = avgValue != null ? avgValue : 1;

//    print('updateReactColorAverage avgHue $avgHue, avgSat $avgSat, avgValue $avgValue, colorReactionCount: $colorReactionCount');
//    print(avgValue);
//    print(avgSat);
//    print(avgHue);
//    print('###### Old reactionColor $reactionColor');
    reactionColor = HSVColor.fromAHSV(1.0, avgHue, avgSat, avgValue).toColor();
//    print('###### new reactionColor $reactionColor');
  }

  void updateUserReactColor({Map data}) {
    double hue = 360;
    double saturation = 0;
    double value = 1;

    if (data != null) {
      hue = data['hue'];
      saturation = data['saturation'];
      value = data['lightness'];
    }

    hue = hue != null ? hue : 1;
    saturation = saturation != null ? saturation : 1;
    value = value != null ? value : 1;

//    print('hue: $hue, saturation: $saturation, value: $value');

    userSelectedColor =
          HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }
}
