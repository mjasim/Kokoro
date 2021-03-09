import 'package:flutter/material.dart';
import 'package:kokoro/ui/auth/sign_in/signin_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Sign in view');
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
            child: Column(
          children: [
            MaterialButton(
              child: Text('Press to Log in Button'),
              onPressed: () {
                model.signInButtonPressed();
              },
            ),
            MaterialButton(
              child: Text('Make an account'),
              onPressed: () {
                model.makeAccount();
              },
            ),
          ],
        )),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }
}
