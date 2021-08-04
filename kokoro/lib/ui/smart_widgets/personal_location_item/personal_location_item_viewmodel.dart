import 'package:stacked/stacked.dart';
import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/core/services/firebase_functions_service.dart';
import 'package:kokoro/core/services/user_information_service.dart';

class PersonalLocationItemViewModel extends BaseViewModel {
  FirebaseFunctionsService _functionsService = locator<FirebaseFunctionsService>();
  UserInformationService _userInformationService = locator<UserInformationService>();

  bool isClicked = false;
  double zoom;

  void clicked(mapCallback) {
    isClicked = !isClicked;
    print('clicked: ${isClicked}, zoom:${zoom}');
    if(zoom < 5 && isClicked) {
      print('clicked Callback');
      mapCallback();
    }
    notifyListeners();
  }

  void setZoom(z) {
    zoom = z;
  }

  // Get personalMapData (note: startDate & stopdate = DateTime.utc(yyyy, mm, dd))
  Future<Map> userPersonalMapData(startDate, stopDate) async {
    dynamic userInfo = await _userInformationService.getUserInfo();
    return await _functionsService.getPersonalMapData(
        userInfo["uid"], startDate, stopDate);
  }

//  // Call the backend to access profileUrls for the accounts at the given location.
//  Future<List<Map>> getProfileData(String locationId, startDate, stopDate) async {
//
//    List<Map> profileUrlList = [];
//
//    dynamic personalMapData = await userPersonalMapData(startDate, stopDate);
//    dynamic incomingProfileList = personalMapData["incoming"][locationId];
//    dynamic outgoingProfileList = personalMapData["outgoing"][locationId];
//    dynamic userInfoData = personalMapData["userInfo"];
//
//    incomingProfileList.forEach((userId, count) { // Go through all profiles for that location
//      // Get user's profile url
//      profileUrlList.add(userInfoData[userId]);
//    });
//
//    outgoingProfileList.forEach((userId, count) { // Go through all profiles for that location
//      // Get user's profile url
//      if (!profileUrlList.contains(userId)){
//        profileUrlList.add(userInfoData[userId]);
//      }
//    });
//
//    print("PROFILE URL LIST: ${profileUrlList}");
//
//    return profileUrlList;
//  }

//  // Convert profileData from Future<List<Map>>
//  List<Map> getProfileListData(String locationId, startDate, stopDate) {
//    Future<List<Map>> _futureList = getProfileData(locationId, startDate, stopDate);
//    List<Map> list = await _futureList;
//    return list;
//  }
}
