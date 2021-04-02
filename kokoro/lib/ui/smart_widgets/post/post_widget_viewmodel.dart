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
  bool userHasInteractedWithSlider = false;

  void init(PostModel _post) async {
    post = _post;

    post.userReactionAmount = await _databaseService.getUserSliderReactionAmount(postUid: post.postUid, reactorUid: _authService.userUid);
    print('postuserReactionAmount ${post.userReactionAmount}');
    if (post.userReactionAmount == null) {
      userHasInteractedWithSlider = false;
      post.userReactionAmount = 50;
    } else {
      userHasInteractedWithSlider = true;
    }
    comments += await _databaseService.getComments(post.postUid);
    print('Comments: $comments');
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

  void updateUserSliderReactionFinal(value) async {
    print('updateSlider final $userHasInteractedWithSlider');
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
    print('Comment Text $comment');
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
