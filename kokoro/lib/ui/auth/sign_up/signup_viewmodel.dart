import 'package:kokoro/app/app.locator.dart';
import 'package:kokoro/app/app.router.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:kokoro/core/services/firebase_auth_service.dart';
import 'package:kokoro/core/services/firebase_database_service.dart';


class SignUpViewModel extends BaseViewModel {
  final _nagivationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthService>();
  final _databaseService = locator<FirebaseDatabaseService>();

  void makeAccount(String email, String password, String location,
                   String name, String username, String birthday,
                   String gender, String aboutMe) async {

    print("Email:    ${email}");
    print("Password: ${password}");
    print("Location: ${location}");
    print("Name:     ${name}");
    print("Username: ${username}");
    print("Birthday: ${birthday}");
    print("Gender:   ${gender}");
    print("About Me: ${aboutMe}");

    FirebaseAuthenticationResult authResult = await _authService.createAccountWithEmail(email: email, password: password);
    if (!authResult .hasError) {
      String uid = authResult.uid;
      print(authResult.uid);
      var databaseResult = await _databaseService.createUser(uid: uid, username: 'Dough', email: email, location: location);
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

  void goToLogIn() {
    _nagivationService.navigateTo(Routes.signInView);
  }
}