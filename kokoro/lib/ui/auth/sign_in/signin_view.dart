import 'package:flutter/material.dart';
import 'package:kokoro/ui/auth/sign_in/signin_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();

}

class _SignInViewState extends State<SignInView> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Sign in view');
    return ViewModelBuilder<SignInViewModel>.reactive(

      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Container( // Creating a box
                height: 550.0,
                width: 550.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 8,
                  ),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset('images/ying-yang-3.jpg',
                      height: 130,
                      width: 130,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('KOKORO', // "KOKORO" Title
                      style: TextStyle(color: Colors.blue, fontSize: 30.0),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container( // Type in Username
                      width: 500,
                      child: TextField(
                          controller: _usernameController,
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                          decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.blue, fontSize: 17.0),
                            fillColor: Colors.black,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    style: BorderStyle.solid,
                                    width: 3)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    style: BorderStyle.solid,
                                    width: 4
                                )
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container( // Type in Password
                      width: 500,
                      child: TextField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.blue, fontSize: 17.0),
                            fillColor: Colors.black,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    style: BorderStyle.solid,
                                    width: 3)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    style: BorderStyle.solid,
                                    width: 4
                                )
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Colors.blue,
                        child: Align(
                          alignment: Alignment.center,
                          widthFactor: 1.7,
                          heightFactor: 1.2,
                          child: Text('Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              height: 1.7,
                            ),
                          ),
                        ),
                        onPressed: () {
                          String username = _usernameController.text;
                          String password = _passwordController.text;
                          print("Username: ${username} Password: ${password}");
                          model.signInButtonPressed(username, password);
//                          model.signInButtonPressed('jfk@real.com', '123456hd');
                          model.navigateToGlobalView();
                        }
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?',
                          style:
                          TextStyle(
                              color: Colors.white,
                              fontSize: 17.0
                          ),
                        ),
                        MaterialButton(
                          child: Text('Sign up here',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17.0,
                            ),
                          ),
                          onPressed: () {
                            model.makeAccount();
                          },
                        ),
                      ],
                    ),
                  ],
                )
            )
        ),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }
}
