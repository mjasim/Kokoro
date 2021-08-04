import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';

class UserInformationService {
  String profileUserPhotoUrl;
  String name;
  String username;
  Map location;
  String activeSinceDate;
  String uid;

  final _databaseService = locator<FirebaseDatabaseService>();
  final _authService = locator<FirebaseAuthService>();
  bool alreadyRetrieved = false;

  Future<Map> getUserInfo() async {
    if (!alreadyRetrieved) {
      uid = _authService.userUid;
      print('getUserInfo $uid');
      print('await databaseService: ${await _databaseService.getUserInfo(uid: uid)}');
      Map userInfo = await _databaseService.getUserInfo(uid: uid);
      print('getUserInfo userInfo $userInfo');
      username = userInfo["username"];
      profileUserPhotoUrl = userInfo["profilePhotoUrl"];
      name = userInfo["name"];
      location = userInfo["location"];
      print('location: ${location}');
      print('location is String: ${location is String}');
      if (location is String) {
        location = {'stringLocation': location};
      }
      activeSinceDate = ""; // TODO: Need to create date
    }

    return {
      "profileUserPhotoUrl": profileUserPhotoUrl,
      "username": username,
      "uid": uid,
      "name": name,
      "location": location,
      "activeSinceDate": activeSinceDate,
    };
  }
}