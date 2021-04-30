import 'package:image_picker/image_picker.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/core/models/post_model.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:video_player/video_player.dart';

class PersonalHomeViewModel extends BaseViewModel {
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();
  final _nagivationService = locator<NavigationService>();

  String profileUserPhotoUrl;
  String name = "";
  String location = "";
  String activeSinceDate = "";
  String uid = "";
  String aboutMe = "";
  double sliderValue = 0.0;

  List<PostModel> posts = [];
  Map<int, VideoPlayerController> videoControllers = {};

  Future init(String _uid) async {
    uid = _uid; // Get uid given
    Map userInfo = await _databaseService.getUserInfo(uid: uid); // Get userInfo with given uid

    print(userInfo); // Print userInfo (to check that it does work)

    profileUserPhotoUrl = userInfo["profilePhotoUrl"];
    name = userInfo["name"];
    location = userInfo["location"];
    activeSinceDate = ""; // TODO: Need to create date
    aboutMe = userInfo["aboutMe"];

    getPosts();
    notifyListeners();
  }

  Future getPosts() async {
    var newPosts = await _databaseService.getUserPosts(uid);
    newPosts.asMap().forEach((index, element) async {
      if (element.contentType == "video") {
        videoControllers[posts.length + index] = VideoPlayerController.network(element.contentUrl);
        await videoControllers[posts.length + index].initialize();
        notifyListeners();
      }
    });

    posts += newPosts;
    notifyListeners();
  }

  void updateSliderValue(double value) {
    sliderValue = value;
    notifyListeners();
  }

  void updateUserSliderReaction(index, value) {
    posts[index].userReactionAmount = value;
    notifyListeners();
  }

  void disposeVideoControllers() {

  }

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

  void navigateToPersonalView() {
    _nagivationService.navigateTo(Routes.personalView);
  }
}