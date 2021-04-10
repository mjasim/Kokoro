import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/core/models/comment_model.dart';
import 'package:kokoro/core/models/post_model.dart';
import 'package:stacked/stacked.dart';
import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';

class PostWidgetModel extends BaseViewModel {
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();

  PostModel post;
  List<CommentModel> comments = [];
  String comment;
  Map userPickedColorValues;
  Map previousPickedColorValues;
  bool userHasInteractedWithSlider = false;
  bool userHasInteractedWithColor = false;

  void init(PostModel _post) async {
    post = _post;

    post.userReactionAmount =
        await _databaseService.getUserSliderReactionAmount(
            postUid: post.postUid, reactorUid: _authService.userUid);
    Map colorData = await _databaseService.getUserColorReactionValue(
        postUid: post.postUid, reactorUid: _authService.userUid);

    if (colorData == null) {
      userHasInteractedWithColor = false;
      previousPickedColorValues = {
        'hue': 0,
        'saturation': 0,
        'lightness': 0,
      };
    } else {
      userHasInteractedWithColor = true;
      previousPickedColorValues = colorData;
    }

//    print('serverColorData $colorData');
    post.updateUserReactColor(data: colorData);

//    print('postuserReactionAmount ${post.userReactionAmount}');
    if (post.userReactionAmount == null) {
      userHasInteractedWithSlider = false;
      post.userReactionAmount = 50;
    } else {
      userHasInteractedWithSlider = true;
    }
    comments += await _databaseService.getComments(post.postUid);
//    print('Comments: $comments');
    notifyListeners();
  }

  String photoUrl() {
    if (post.contentType == "image") {
      return post.contentUrl;
    } else {
      return null;
    }
  }

  void updateUserSliderReaction(value) {
    post.userReactionAmount = value;
    notifyListeners();
  }

  void updateUserColorReaction({hue, saturation, lightness, alpha}) async {
    userPickedColorValues = {
      'hue': hue,
      'saturation': saturation,
      'lightness': lightness
    };
    post.updateUserReactColor(data: userPickedColorValues);
//    post.updateReactColorAverageWithUserChange();
    notifyListeners();
  }

  void updateUserColorReactionFinal() async {
    if (!userHasInteractedWithColor) {
      post.colorReactionCount += 1;
    }
    post.updateReactColorAverage(
      userHueChange:
      previousPickedColorValues['hue'] - userPickedColorValues['hue'],
      userLightnessChange:
      previousPickedColorValues['lightness'] - userPickedColorValues['lightness'],
      userSaturationChange:
      previousPickedColorValues['saturation'] - userPickedColorValues['saturation'],
    );
    if (!userHasInteractedWithColor) {
      await _databaseService.createColorReact(
        uid: _authService.userUid,
        postUid: post.postUid,
        postAuthorUid: post.authorUid,
        hueValue: userPickedColorValues['hue'],
        saturationValue: userPickedColorValues['saturation'],
        lightnessValue: userPickedColorValues['lightness'],
        postType: post.contentType,
      );
    } else {
      await _databaseService.updateColorReact(
        uid: _authService.userUid,
        postUid: post.postUid,
        hueValue: userPickedColorValues['hue'],
        saturationValue: userPickedColorValues['saturation'],
        lightnessValue: userPickedColorValues['lightness'],
      );
    }
    previousPickedColorValues = userPickedColorValues;
    userHasInteractedWithColor = true;
    notifyListeners();
  }

  void updateUserSliderReactionFinal(value) async {
//    print('updateSlider final $userHasInteractedWithSlider');
    post.userReactionAmount = value;

    if (!userHasInteractedWithSlider) {
      post.sliderReactionCount += 1;
      await _databaseService.createSliderReact(
        uid: _authService.userUid,
        postUid: post.postUid,
        postAuthorUid: post.authorUid,
        sliderValue: value,
      );
    } else {
      await _databaseService.updateSliderReact(
        uid: _authService.userUid,
        postUid: post.postUid,
        sliderValue: value,
      );
    }
    userHasInteractedWithSlider = true;
    notifyListeners();
  }

  void toggleComments() {
    post.commentsOpen = !post.commentsOpen;
    notifyListeners();
  }

  void postComment() async {
//    print('Comment Text $comment');
    String text = comment;
    _databaseService.createComment(
      uid: _authService.userUid,
      username: await _databaseService.getUsername(uid: _authService.userUid),
      commentText: text,
      profilePhotoUrl: '',
      postAuthorUid: post.authorUid,
      postUid: post.postUid,
    );

    comments.insert(
        0,
        CommentModel(
          commentText: text,
          username:
              await _databaseService.getUsername(uid: _authService.userUid),
          postAuthorUid: post.authorUid,
          postUid: post.postUid,
          authorUid: _authService.userUid,
          authorProfilePhotoUrl:
              'https://images.generated.photos/0Ok6OTj1BHb-WO_vQAIO6A9VSUVeSdmKTmKZm28FO7E/rs:fit:512:512/wm:0.95:sowe:18:18:0.33/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3Njk5ODUuanBn.jpg',
        ));

    post.commentCount += 1;
    notifyListeners();
  }

  void commentOnChange(text) {
    comment = text;
  }
}
