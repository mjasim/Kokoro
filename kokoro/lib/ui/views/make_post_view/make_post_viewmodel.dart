import 'dart:io';
import 'package:kokoro/core/services/user_information_service.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/core/services/firebase_storage_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';
import 'package:kokoro/core/services/firebase_storage_service.dart';
import 'package:video_player/video_player.dart';

class MakePostViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();
  final _storageService = locator<FirebaseStorageService>();
  final _userInformationService = locator<UserInformationService>();

  final _uuid = Uuid();

  final ImagePicker _picker = ImagePicker();
  VideoPlayerController controller;
  File imageFile;
  File videoFile;

  PickedFile imagePickedFile;
  PickedFile videoPickedFile;

  List<String> planets = [];

  void makePost(String postText) async {
    if (_authService.hasUser) {
      print("has user");
      String uid = _authService.userUid;
      String contentType;
      String contentUrl;
      if (imageFile != null) {
        final imageData = await imagePickedFile.readAsBytes();
        contentType = "image";
        contentUrl = await _storageService.uploadPostPhoto(
            imageData: imageData, fileName: _uuid.v4());
      } else if (videoFile != null) {
        final videoData = await videoPickedFile.readAsBytes();
        contentType = "video";
        contentUrl = await _storageService.uploadPostVideo(
            videoData: videoData, fileName: _uuid.v4());
      }

//      Map userInfo = await _userInformationService.getUserInfo();

      _databaseService.createPost(
          uid: uid,
          username: "PersonA",
          contentType: contentType,
          postText: postText,
          contentUrl: contentUrl,
//          authorProfilePhotoUrl: userInfo['profileUserPhotoUrl'],
          authorProfilePhotoUrl: 'https://images.generated.photos/ZO-Q3P2TwLgXvFyNOvKDhrpmuVeEQaiDb1dBoVR9kuU/rs:fit:256:256/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3NTE2MzAuanBn.jpg',
          planets: planets,
      );
    } else {
      print("does NOT have user");
    }
  }

  void onPlanetTextChange(String planetText) {
    planets = planetText.split(',').map<String>((e) => e.trim()).toList();
    notifyListeners();
  }

  void pickImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    imagePickedFile = pickedFile;
    imageFile = File(pickedFile.path);
    videoFile = null;
    notifyListeners();
  }

  void pickVideo() async {
    final pickedFile = await _picker.getVideo(
      source: ImageSource.gallery,
    );
    videoFile = File(pickedFile.path);
    imageFile = null;
    videoPickedFile = pickedFile;
    controller = VideoPlayerController.network(
      videoFile.path,
    );
    await controller.initialize();
    controller.play();
    notifyListeners();
  }
}
