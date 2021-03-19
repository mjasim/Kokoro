import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';
import 'package:kokoro/core/models/post_model.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';

class HomeViewModel extends BaseViewModel {
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();

  List<PostModel> posts = [];

  Future getPosts() async {
    var newPosts = await _databaseService.getPosts();
    posts += newPosts;
    notifyListeners();
  }

  void updateUserSliderReaction(index, value) {
    posts[index].userReactionAmount = value;
    notifyListeners();
  }
}