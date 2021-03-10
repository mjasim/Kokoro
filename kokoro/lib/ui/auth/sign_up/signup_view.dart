import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kokoro/ui/auth/sign_up/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
    const SignUpView({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return ViewModelBuilder<SignUpViewModel>.reactive(
            builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  AppBar(
                    title: Text('KOKORO',
                        style: TextStyle(color: Colors.black, fontSize: 20.0)),
//                    actions: [
//                      Padding(
//                      ),
//                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container( // Creating a box
                    height: 550.0,
                    width: 1100.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 8,
                      ),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7, // 70%
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text('Create a new account', // Title
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.blue, fontSize: 25.0)
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row( // Username
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                          children: [
                                            Text('Username *',
                                              style:
                                              TextStyle(color: Colors.blue, fontSize: 17.0),
                                              textAlign: TextAlign.left,
                                            ),
                                          ]
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Container( // Type in Username
                                                width: 400,

                                                child: TextField(
                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.black,
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 2.5)
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 3
                                                          )
                                                      ),
                                                    )
                                                ),
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row( // Password
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                            children: [
                                              Text('Password *',
                                                style:
                                                TextStyle(color: Colors.blue, fontSize: 17.0),
                                              ),
                                            ]
                                        )
                                    ),
                                    Expanded(
                                        flex: 8,
                                        child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Container( // Type in Username
                                                  width: 400,
                                                  child: TextField(
                                                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                      decoration: InputDecoration(
                                                        fillColor: Colors.black,
                                                        filled: true,
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                                color: Colors.blue,
                                                                style: BorderStyle.solid,
                                                                width: 2.5)
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                                color: Colors.blue,
                                                                style: BorderStyle.solid,
                                                                width: 3
                                                            )
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              )
                                            ]
                                        )
                                    )
                                  ]
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row( // Location
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                          children: [
                                            Text('Location *',
                                              style:
                                              TextStyle(color: Colors.blue, fontSize: 17.0),
                                            ),
                                          ]
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Container( // Type in Username
                                                width: 400,
                                                child: TextField(
                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.black,
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 2.5)
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 3
                                                          )
                                                      ),
                                                    )
                                                ),
                                              ),
                                            )
                                          ]
                                      )
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                  ),
                                  Image.asset('images/information-icon.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('All information except the password will be public',
                                    style: TextStyle(color: Colors.blue, fontSize: 17.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row( // Name
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                          children: [
                                            Text('Name',
                                              style:
                                              TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17.0
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Container( // Type in Username
                                                width: 400,
                                                child: TextField(
                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.black,
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 2.5)
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 3
                                                          )
                                                      ),
                                                    )
                                                ),
                                              ),
                                            )
                                          ]
                                      )
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row( // Birthday
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                          children: [
                                            Text('Birthday',
                                              style:
                                              TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17.0
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Container( // Type in Username
                                                width: 400,
                                                child: TextField(
                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.black,
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 2.5)
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 3
                                                          )
                                                      ),
                                                    )
                                                ),
                                              ),
                                            )
                                          ]
                                      )
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row( // Gender
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                          children: [
                                            Text('Gender',
                                              style:
                                              TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17.0
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Container( // Type in Username
                                                width: 400,
                                                child: TextField(
                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.black,
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 2.5)
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue,
                                                              style: BorderStyle.solid,
                                                              width: 3
                                                          )
                                                      ),
                                                    )
                                                ),
                                              ),
                                            )
                                          ]
                                      )
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3, // 30%
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80,
                              ),
                              Image.asset('images/person-icon.png',
                                height: 170,
                                width: 170,
                                alignment: Alignment.center,
                              ),
                              SizedBox(
                                height: 210,
                              ),
                              MaterialButton( // Sign up button after submitting information
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Colors.blue,
                                child: Align(
                                  alignment: Alignment.center,
                                  widthFactor: 1.7,
                                  heightFactor: 1.2,
                                  child: Text('Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  model.goToLogIn();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ),
            ),
            viewModelBuilder: () => SignUpViewModel(),
        );
    }
}