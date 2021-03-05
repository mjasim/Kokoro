import 'package:flutter/material.dart';
import 'package:kokoro/ui/auth/sign_up/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
    const SignUpView({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return ViewModelBuilder<SignUpViewModel>.reactive(
            builder: (context, model, child) => Scaffold(
              body: Center(
                child: Column(
                  children: [
                    MaterialButton(
                      child: Text('Click to make account'),
                      onPressed: () {
                        model.makeAccount('test@real.com', '123456hd');
                      },
                    ),
                    MaterialButton(
                      child: Text('Log in'),
                      onPressed: () {
                        model.goToLogIn();
                      },
                    ),
                  ],
                )
              ),
            ),
            viewModelBuilder: () => SignUpViewModel(),
        );
    }
}