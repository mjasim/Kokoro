import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';

class UserInformationService {
  String profileUserPhotoUrl;
  String name;
  String location;
  String activeSinceDate;
  String uid;

  final _databaseService = locator<FirebaseDatabaseService>();
  final _authService = locator<FirebaseAuthService>();
  bool alreadyRetrieved = false;

  Future<Map> getUserInfo() async {
    if (!alreadyRetrieved) {
      uid = _authService.userUid;
      Map userInfo = await _databaseService.getUserInfo(uid: uid);

      profileUserPhotoUrl = userInfo["profilePhotoUrl"];
      name = userInfo["name"];
      location = userInfo["location"];
      activeSinceDate = ""; // TODO: Need to create date
    }

    return {
      "profileUserPhotoUrl": profileUserPhotoUrl,
      "name": name,
      "location": location,
      "activeSinceDate": activeSinceDate,
    };
  }
}