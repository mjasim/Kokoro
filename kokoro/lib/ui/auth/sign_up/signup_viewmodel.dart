import 'dart:io';
import 'package:kokoro/core/services/firebase_functions_service.dart';
import 'package:kokoro/core/services/google_location_service.dart';
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

class SignUpViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();
  final _storageService = locator<FirebaseStorageService>();
  final _googleLocationService = locator<GoogleLocationService>();
  final _functionsService = locator<FirebaseFunctionsService>();

  final _uuid = Uuid();

  List<Map> suggestedLocations = [];
  Map selectedLocation;

  final ImagePicker _picker = ImagePicker();
  File imageFile;
  PickedFile imagePickedFile;

  void makeAccount(String email, String password, String location, String name,
      String username, String birthday, String gender, String aboutMe) async {
    print("Email:    ${email}");
    print("Password: ${password}");
    print("Location: ${location}");
    print("Name:     ${name}");
    print("Username: ${username}");
    print("Birthday: ${birthday}");
    print("Gender:   ${gender}");
    print("About Me: ${aboutMe}");

    FirebaseAuthenticationResult authResult = await _authService
        .createAccountWithEmail(email: email, password: password);
    if (!authResult.hasError || true) {
      String uid = authResult.uid;
      String url;
      if (imageFile != null) {
        // Check image is uploaded
        final imageData = await imagePickedFile.readAsBytes();
        url = await _storageService.uploadProfilePhoto(
            fileName: _uuid.v4(), imageData: imageData);
      }

      Map currLocation;
      if (selectedLocation != null) {
        String placeId = selectedLocation['placeId'];
        String country = selectedLocation['country'];
        currLocation = selectedLocation;
        currLocation['cityLatLng'] = await _functionsService.latLngFromPlaceId(placeId);
        currLocation['countryLatLng'] = await _functionsService.latLngFromName(country);

        print('make Account ${currLocation}');
      }


      print(authResult.uid);
      var databaseResult = await _databaseService.createUser(
        uid: uid,
        username: username,
        email: email,
        location: currLocation,
        name: name,
        birthday: birthday,
        gender: gender,
        photoUrl: url,
        aboutMe: aboutMe,
      );
      print(databaseResult.runtimeType);
      print(databaseResult);
    } else {
      print('Auth Error');
      print(authResult.errorMessage);
    }
    // TODO get the result back from the auth service and check it worked
    // TODO then take the id and make a user in the database using the auth id for the user uid
//    print();
  }

  void getSuggestedLocations(String text) async {
    print('getSuggestedLocations $text');
    suggestedLocations = await _functionsService.locationAutoFill(text);
    print('getSuggestedLocations suggestions $suggestedLocations');
    notifyListeners();
  }

  void goToLogIn() {
    _nagivationService.navigateTo(Routes.signInView);
  }

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
      }

      _databaseService.createPost(
          uid: uid,
          username: "PersonA",
          contentType: contentType,
          postText: postText,
          contentUrl: contentUrl);
    } else {
      print("does NOT have user");
    }
  }

  void pickImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    imagePickedFile = pickedFile;
    imageFile = File(pickedFile.path);
    notifyListeners();
  }
}
