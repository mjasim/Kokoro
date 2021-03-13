import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kokoro/ui/auth/sign_up/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();

}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _locationController;
  TextEditingController _nameController;

  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _locationController = TextEditingController();
    _nameController = TextEditingController();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Gets date for birthday input
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  Future<Null> _selectDate(BuildContext context) async {
    DateFormat formatter = DateFormat('MM/dd/yyyy');//specifies month/day/year format

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1801, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: formatter.format(picked));//Use formatter to format selected date and assign to text field
      });
  }

  // Get image for profile picture
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {

      await _displayPickImageDialog(context, (double maxWidth, double maxHeight, int quality) async {
            try {
              final pickedFile = await _picker.getImage(
                source: source,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: quality,
              );
              setState(() {
                _imageFile = pickedFile;
              });
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
          });

  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                  InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                  InputDecoration(hintText: "Enter maxHeight if desired"),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration:
                  InputDecoration(hintText: "Enter quality if desired"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  String genderDropdownValue = 'Choose';

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
                                        Text('Email *',
                                          style: TextStyle(color: Colors.blue, fontSize: 17.0),
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
                                                controller: _emailController,
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
                                            style: TextStyle(color: Colors.blue, fontSize: 17.0),
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
                                                  controller: _passwordController,
                                                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                  obscureText: true,
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
                                                controller: _locationController,
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
                                                controller: _nameController,
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
                                          child: Container( // Type in Birthday
                                            width: 400,
                                            child: TextField(
                                                onTap: () => _selectDate(context),
                                                controller: _date,
                                                keyboardType: TextInputType.datetime,
                                                style: TextStyle(color: Colors.white, fontSize: 17.0),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  fillColor: Colors.black,
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.blue,
                                                        style: BorderStyle.solid,
                                                        width: 2.5
                                                    )
                                                  ),
                                                ),
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
                                          child: Container( // Type in Gender
                                              width: 400,
                                              child: DropdownButton<String>(
                                                value: genderDropdownValue,
                                                icon: Icon(Icons.arrow_downward, color: Colors.blue,),
                                                iconSize: 28,
                                                elevation: 16,
                                                style: TextStyle(color: Colors.blue),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.blue,
                                                ),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    genderDropdownValue = newValue;
                                                  });
                                                },
                                                items: <String>['Choose', 'Male', 'Female', 'Other']
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              )
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
                          CircleAvatar(
                            radius: 80,
                            child: Icon(Icons.account_circle, size: 150, color: Colors.blue),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.blue,
                            onPressed: () {
                              _onImageButtonPressed(ImageSource.gallery, context: context);
                            },
                            child: Icon(Icons.open_in_browser),
                          ),
                          SizedBox(
                            height: 150,
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
                              String username = _emailController.text;
                              String password = _passwordController.text;
                              String location = _locationController.text;
                              String name = _nameController.text;
                              String birthday = _date.text;
                              String gender = genderDropdownValue;

                              model.makeAccount(username, password, location,
                                  name, birthday, gender);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

//class SignUpView extends StatelessWidget {
//    const SignUpView({Key key}) : super(key: key);
//
//    String dropdownValue = 'Choose';
//
//    @override
//    Widget build(BuildContext context) {
//        return ViewModelBuilder<SignUpViewModel>.reactive(
//            builder: (context, model, child) => Scaffold(
//              backgroundColor: Colors.black,
//              body: Column(
//                children: [
//                  AppBar(
//                    title: Text('KOKORO',
//                        style: TextStyle(color: Colors.black, fontSize: 20.0)),
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
//                  Container( // Creating a box
//                    height: 550.0,
//                    width: 1100.0,
//                    decoration: BoxDecoration(
//                      border: Border.all(
//                        color: Colors.blue,
//                        width: 8,
//                      ),
//                      color: Colors.black,
//                      borderRadius: BorderRadius.circular(12),
//                    ),
//                    child: Row(
//                      children: [
//                        Expanded(
//                          flex: 7, // 70%
//                          child: Column(
//                            children: [
//                              SizedBox(
//                                height: 20,
//                              ),
//                              Text('Create a new account', // Title
//                                  textAlign: TextAlign.left,
//                                  style: TextStyle(color: Colors.blue, fontSize: 25.0)
//                              ),
//                              SizedBox(
//                                height: 20,
//                              ),
//                              Row( // Username
//                                children: [
//                                  Expanded(
//                                      flex: 2,
//                                      child: Column(
//                                          children: [
//                                            Text('Email *',
//                                              style:
//                                              TextStyle(color: Colors.blue, fontSize: 17.0),
//                                              textAlign: TextAlign.left,
//                                            ),
//                                          ]
//                                      )
//                                  ),
//                                  Expanded(
//                                      flex: 8,
//                                      child: Column(
//                                          children: [
//                                            Container(
//                                              alignment: Alignment.centerLeft,
//                                              child: Container( // Type in Username
//                                                width: 400,
//
//                                                child: TextField(
//                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
//                                                    decoration: InputDecoration(
//                                                      fillColor: Colors.black,
//                                                      filled: true,
//                                                      focusedBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 2.5)
//                                                      ),
//                                                      enabledBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 3
//                                                          )
//                                                      ),
//                                                    )
//                                                ),
//                                              ),
//                                            )
//                                          ]
//                                      )
//                                  ),
//                                ],
//                              ),
//                              SizedBox(
//                                height: 15,
//                              ),
//                              Row( // Password
//                                  children: [
//                                    Expanded(
//                                        flex: 2,
//                                        child: Column(
//                                            children: [
//                                              Text('Password *',
//                                                style:
//                                                TextStyle(color: Colors.blue, fontSize: 17.0),
//                                              ),
//                                            ]
//                                        )
//                                    ),
//                                    Expanded(
//                                        flex: 8,
//                                        child: Column(
//                                            children: [
//                                              Container(
//                                                alignment: Alignment.centerLeft,
//                                                child: Container( // Type in Username
//                                                  width: 400,
//                                                  child: TextField(
//                                                      style: TextStyle(color: Colors.white, fontSize: 17.0),
//                                                      decoration: InputDecoration(
//                                                        fillColor: Colors.black,
//                                                        filled: true,
//                                                        focusedBorder: OutlineInputBorder(
//                                                            borderRadius: BorderRadius.circular(8.0),
//                                                            borderSide: BorderSide(
//                                                                color: Colors.blue,
//                                                                style: BorderStyle.solid,
//                                                                width: 2.5)
//                                                        ),
//                                                        enabledBorder: OutlineInputBorder(
//                                                            borderRadius: BorderRadius.circular(8.0),
//                                                            borderSide: BorderSide(
//                                                                color: Colors.blue,
//                                                                style: BorderStyle.solid,
//                                                                width: 3
//                                                            )
//                                                        ),
//                                                      )
//                                                  ),
//                                                ),
//                                              )
//                                            ]
//                                        )
//                                    )
//                                  ]
//                              ),
//                              SizedBox(
//                                height: 15,
//                              ),
//                              Row( // Location
//                                children: [
//                                  Expanded(
//                                      flex: 2,
//                                      child: Column(
//                                          children: [
//                                            Text('Location *',
//                                              style:
//                                              TextStyle(color: Colors.blue, fontSize: 17.0),
//                                            ),
//                                          ]
//                                      )
//                                  ),
//                                  Expanded(
//                                      flex: 8,
//                                      child: Column(
//                                          children: [
//                                            Container(
//                                              alignment: Alignment.centerLeft,
//                                              child: Container( // Type in Username
//                                                width: 400,
//                                                child: TextField(
//                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
//                                                    decoration: InputDecoration(
//                                                      fillColor: Colors.black,
//                                                      filled: true,
//                                                      focusedBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 2.5)
//                                                      ),
//                                                      enabledBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 3
//                                                          )
//                                                      ),
//                                                    )
//                                                ),
//                                              ),
//                                            )
//                                          ]
//                                      )
//                                  )
//                                ],
//                              ),
//                              SizedBox(
//                                height: 20,
//                              ),
//                              Row(
//                                children: [
//                                  SizedBox(
//                                    width: 120,
//                                  ),
//                                  Image.asset('images/information-icon.png',
//                                    height: 25,
//                                    width: 25,
//                                  ),
//                                  SizedBox(
//                                    width: 10,
//                                  ),
//                                  Text('All information except the password will be public',
//                                    style: TextStyle(color: Colors.blue, fontSize: 17.0),
//                                  ),
//                                ],
//                              ),
//                              SizedBox(
//                                height: 20,
//                              ),
//                              Row( // Name
//                                children: [
//                                  Expanded(
//                                      flex: 2,
//                                      child: Column(
//                                          children: [
//                                            Text('Name',
//                                              style:
//                                              TextStyle(
//                                                  color: Colors.blue,
//                                                  fontSize: 17.0
//                                              ),
//                                            ),
//                                          ]
//                                      )
//                                  ),
//                                  Expanded(
//                                      flex: 8,
//                                      child: Column(
//                                          children: [
//                                            Container(
//                                              alignment: Alignment.centerLeft,
//                                              child: Container( // Type in Username
//                                                width: 400,
//                                                child: TextField(
//                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
//                                                    decoration: InputDecoration(
//                                                      fillColor: Colors.black,
//                                                      filled: true,
//                                                      focusedBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 2.5)
//                                                      ),
//                                                      enabledBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 3
//                                                          )
//                                                      ),
//                                                    )
//                                                ),
//                                              ),
//                                            )
//                                          ]
//                                      )
//                                  )
//                                ],
//                              ),
//                              SizedBox(
//                                height: 15,
//                              ),
//                              Row( // Birthday
//                                children: [
//                                  Expanded(
//                                      flex: 2,
//                                      child: Column(
//                                          children: [
//                                            Text('Birthday',
//                                              style:
//                                              TextStyle(
//                                                  color: Colors.blue,
//                                                  fontSize: 17.0
//                                              ),
//                                            ),
//                                          ]
//                                      )
//                                  ),
//                                  Expanded(
//                                      flex: 8,
//                                      child: Column(
//                                          children: [
//                                            Container(
//                                              alignment: Alignment.centerLeft,
//                                              child: Container( // Type in Username
//                                                width: 400,
//                                                child: TextField(
//                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
//                                                    decoration: InputDecoration(
//                                                      fillColor: Colors.black,
//                                                      filled: true,
//                                                      focusedBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 2.5)
//                                                      ),
//                                                      enabledBorder: OutlineInputBorder(
//                                                          borderRadius: BorderRadius.circular(8.0),
//                                                          borderSide: BorderSide(
//                                                              color: Colors.blue,
//                                                              style: BorderStyle.solid,
//                                                              width: 3
//                                                          )
//                                                      ),
//                                                    )
//                                                ),
//                                              ),
//                                            )
//                                          ]
//                                      )
//                                  )
//                                ],
//                              ),
//                              SizedBox(
//                                height: 15,
//                              ),
//                              Row( // Gender
//                                children: [
//                                  Expanded(
//                                      flex: 2,
//                                      child: Column(
//                                          children: [
//                                            Text('Gender',
//                                              style:
//                                              TextStyle(
//                                                  color: Colors.blue,
//                                                  fontSize: 17.0
//                                              ),
//                                            ),
//                                          ]
//                                      )
//                                  ),
//                                  Expanded(
//                                      flex: 8,
//                                      child: Column(
//                                          children: [
//                                            Container(
//                                              alignment: Alignment.centerLeft,
//                                              child: Container( // Type in Username
//                                                width: 400,
//                                                child:
//
//                                                DropdownButton<String>(
//                                                  value: dropdownValue,
//                                                  icon: Icon(Icons.arrow_downward),
//                                                  iconSize: 24,
//                                                  elevation: 16,
//                                                  style: TextStyle(color: Colors.deepPurple),
//                                                  underline: Container(
//                                                    height: 2,
//                                                    color: Colors.deepPurpleAccent,
//                                                  ),
//                                                  onChanged: (String ? newValue) {
//                                                    setState(() {
//                                                      dropdownValue = newValue!;
//                                                    });
//                                                  },
//                                                  items: <String>['One', 'Two', 'Free', 'Four']
//                                                      .map<DropdownMenuItem<String>>((String value) {
//                                                    return DropdownMenuItem<String>(
//                                                      value: value,
//                                                      child: Text(value),
//                                                    );
//                                                  }).toList(),
//                                                )
//
////                                                TextField(
////                                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
////                                                    decoration: InputDecoration(
////                                                      fillColor: Colors.black,
////                                                      filled: true,
////                                                      focusedBorder: OutlineInputBorder(
////                                                          borderRadius: BorderRadius.circular(8.0),
////                                                          borderSide: BorderSide(
////                                                              color: Colors.blue,
////                                                              style: BorderStyle.solid,
////                                                              width: 2.5)
////                                                      ),
////                                                      enabledBorder: OutlineInputBorder(
////                                                          borderRadius: BorderRadius.circular(8.0),
////                                                          borderSide: BorderSide(
////                                                              color: Colors.blue,
////                                                              style: BorderStyle.solid,
////                                                              width: 3
////                                                          )
////                                                      ),
////                                                    )
////                                                ),
//                                              ),
//                                            )
//                                          ]
//                                      )
//                                  )
//                                ],
//                              ),
//                              SizedBox(
//                                height: 20,
//                              ),
//                            ],
//                          ),
//                        ),
//                        Expanded(
//                          flex: 3, // 30%
//                          child: Column(
//                            children: [
//                              SizedBox(
//                                height: 80,
//                              ),
//                              Icon(Icons.account_circle, size: 170, color: Colors.blue),
//                              SizedBox(
//                                height: 210,
//                              ),
//                              MaterialButton( // Sign up button after submitting information
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(8.0),
//                                ),
//                                color: Colors.blue,
//                                child: Align(
//                                  alignment: Alignment.center,
//                                  widthFactor: 1.7,
//                                  heightFactor: 1.2,
//                                  child: Text('Sign Up',
//                                    textAlign: TextAlign.center,
//                                    style: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 17.0,
//                                      height: 1.7,
//                                    ),
//                                  ),
//                                ),
//                                onPressed: () {
//                                  model.goToLogIn();
//                                },
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  )
//                ]
//              ),
//            ),
//            viewModelBuilder: () => SignUpViewModel(),
//        );
//    }
//}