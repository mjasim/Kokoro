import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';

class MakePostViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();

  void makePost(String content) async {

    if(_authService.hasUser) {
      print("has user");
      String uid = await _authService.userUid;
      _databaseService.createPost(uid: uid, username: "PersonA",
          contentType: "text", content: content);
    } else {
      print("does NOT have user");
    }
  }
}