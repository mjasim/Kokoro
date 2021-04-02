import 'package:image_picker/image_picker.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/core/models/post_model.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:video_player/video_player.dart';

class HomeViewModel extends BaseViewModel {
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();

  List<PostModel> posts = [];
  Map<int, VideoPlayerController> videoControllers = {};
  Map<int, String> comments = {};

  Future getPosts() async {
    var newPosts = await _databaseService.getPosts();
    newPosts.asMap().forEach((index, element) async {
      if (element.contentType == "video") {
        videoControllers[posts.length + index] =
            VideoPlayerController.network(element.contentUrl);
        await videoControllers[posts.length + index].initialize();
        notifyListeners();
      }
    });

    posts += newPosts;
    notifyListeners();
  }

  void commentOnChange(index, text) {
    comments[index] = text;
  }

  void postComment(index) async {
    String text = comments[index];
    _databaseService.createComment(
      uid: _authService.userUid,
      username: await _databaseService.getUsername(uid: _authService.userUid),
      commentText: text,
      profilePhotoUrl: '',
      postUid: posts[index].postUid,
    );
  }

  void updateUserSliderReaction(index, value) {
    posts[index].userReactionAmount = value;
    notifyListeners();
  }

  void toggleComments(index) {
    posts[index].commentsOpen = !posts[index].commentsOpen;
    notifyListeners();
  }

  void disposeVideoControllers() {}

  bool hasVideo(index) {
    return videoControllers.containsKey(index);
  }

  VideoPlayerController getController(index) {
    if (videoControllers.containsKey(index)) {
//      videoControllers[index].play();
      return videoControllers[index];
    } else {
      return null;
    }
  }

  String photoUrl(index) {
    if (posts[index].contentType == "image") {
      return posts[index].contentUrl;
    } else {
      return null;
    }
  }
}
