import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kokoro/ui/auth/sign_up/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter/material.dart';
import 'dart:math';

const kGoogleApiKey = "AIzaSyB4vwPM5fwg6M-LUoo6mqbflDtDNXodOKs";

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _locationController;
  TextEditingController _nameController;
  TextEditingController _userNameController;
  TextEditingController _otherGenderController;
  TextEditingController _aboutMeController;
  TextEditingController _postProfileController;

  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _locationController = TextEditingController();
    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _otherGenderController = TextEditingController();
    _aboutMeController = TextEditingController();
    _postProfileController = TextEditingController();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _otherGenderController.dispose();
    _aboutMeController.dispose();
    _postProfileController.dispose();
    super.dispose();
  }

  // Gets date for birthday input
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  Future<Null> _selectDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('MM/dd/yyyy'); //specifies month/day/year format

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1801, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(
            text: formatter.format(
                picked)); //Use formatter to format selected date and assign to text field
      });
  }

  String genderDropdownValue = 'Choose'; // Gets choice of gender
  bool otherTextFieldEnabled = false; // Enable/Disable text field for Gender input

  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Column(children: [
              AppBar(
                title: Text('KOKORO',
                    style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // Creating a box
                height: 800.0,
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
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 25.0)),
                          SizedBox(
                            height: 20,
                          ),
                          customTextInput('Email *', _emailController, false),
                          SizedBox(
                            height: 15,
                          ),
                          customTextInput(
                              'Password *', _passwordController, true),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => model.getSuggestedLocations(_locationController.text),
                                child: Text("Search places"),
                              ),
                            ],
                          ),
                          customTextInput(
                              'Location', _locationController, false),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                              ),
                              Image.asset(
                                'images/information-icon.png',
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'All information except the password will be public',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 17.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          customTextInput('Name', _nameController, false),
                          SizedBox(
                            height: 15,
                          ),
                          customTextInput(
                              'Username *', _userNameController, false),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            // Birthday
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(children: [
                                    Text(
                                      'Birthday',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 17.0),
                                    ),
                                  ])),
                              Expanded(
                                  flex: 8,
                                  child: Column(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        // Type in Birthday
                                        width: 400,
                                        child: TextField(
                                          onTap: () => _selectDate(context),
                                          controller: _date,
                                          keyboardType: TextInputType.datetime,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.black,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    style: BorderStyle.solid,
                                                    width: 2.5)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]))
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            // Gender
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(children: [
                                    Text(
                                      'Gender',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 17.0),
                                    ),
                                  ])),
                              Expanded(
                                  flex: 8,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            // Type in Gender
                                            width: 400,
                                            child: DropdownButton<String>(
                                              value: genderDropdownValue,
                                              icon: Icon(Icons.arrow_downward,
                                                  color: Colors.blue),
                                              iconSize: 28,
                                              elevation: 16,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.blue,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  genderDropdownValue =
                                                      newValue;
                                                });

                                                // Enable or disable "Other" gender input
                                                if (newValue == 'Other') {
                                                  otherTextFieldEnabled = true;
                                                } else {
                                                  otherTextFieldEnabled = false;
                                                }
                                              },
                                              items: <String>[
                                                'Choose',
                                                'Male',
                                                'Female',
                                                'Other'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            )),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          // Add gender input box if "Other" is selected
                          otherTextFieldEnabled
                              ? genderTextInput(_otherGenderController)
                              : Row(),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            // Location
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(children: [
                                    Text(
                                      'About Me',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 17.0),
                                    ),
                                  ])),
                              Expanded(
                                  flex: 8,
                                  child: Column(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        // Type in Other Gender
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        width: 400,
                                        height: 100,
                                        child: TextField(
                                            minLines: 50,
                                            maxLines: 100,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.0),
                                            controller: _aboutMeController,
                                            decoration: InputDecoration(
                                              fillColor: Colors.black,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      style: BorderStyle.solid,
                                                      width: 2.5)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      style: BorderStyle.solid,
                                                      width: 3)),
                                            )),
                                      ),
                                    )
                                  ]))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3, // 30%
                      child: Column( // TODO: Need to find out how to add profile pic in textfield
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(80.0),
                              topRight: Radius.circular(80.0),
                              bottomLeft: Radius.circular(80.0),
                              bottomRight: Radius.circular(80.0),
                            ),
                            child: model.imageFile != null ?
                              new Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                          model.imageFile.path,
                                        )
                                    )
                                )
                              ) :
                              Icon(Icons.account_circle,
                                  size: 200.0, color: Colors.blue),
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
                              model.pickImage();
                            },
                            child: Icon(Icons.open_in_browser),
                          ),
                          SizedBox(
                            height: 210,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            // Sign up button after submitting information
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.blue,
                            child: Align(
                              alignment: Alignment.center,
                              widthFactor: 1.7,
                              heightFactor: 1.2,
                              child: Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  height: 1.7,
                                ),
                              ),
                            ),
                            onPressed: () {
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              String location = _locationController.text;
                              String name = _nameController.text;
                              String username = _userNameController.text;
                              String birthday = _date.text;
                              String gender = genderDropdownValue;
                              if (genderDropdownValue == 'Other') {
                                gender = _otherGenderController.text;
                              }
                              String aboutMe = _aboutMeController.text;

                              model.makeAccount(email, password, location, name,
                                  username, birthday, gender, aboutMe);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }

  Widget _buildDropdownMenu() => DropdownButton(
    value: _mode,
    items: <DropdownMenuItem<Mode>>[
      DropdownMenuItem<Mode>(
        child: Text("Overlay"),
        value: Mode.overlay,
      ),
      DropdownMenuItem<Mode>(
        child: Text("Fullscreen"),
        value: Mode.fullscreen,
      ),
    ],
    onChanged: (m) {
      setState(() {
        _mode = m;
      });
    },
  );

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      proxyBaseUrl: "https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api",
      onError: onError,
      mode: _mode,
      language: "en",
      components: [Component(Component.country, "en")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }
}

// Custom Text Input Formatting Helper
class customTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  customTextInput(this.label, this.controller, this.obscureText);

  @override
  Widget build(BuildContext context) {
    return Row(
      // Username
      children: [
        Expanded(
            flex: 2,
            child: Column(children: [
              Text(
                label,
                style: TextStyle(color: Colors.blue, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
            ])),
        Expanded(
            flex: 8,
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  // Type in Username
                  width: 400,
                  child: TextField(
                      controller: controller,
                      obscureText: obscureText,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                                width: 2.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                                width: 3)),
                      )),
                ),
              )
            ])),
      ],
    );
  }
}

// State Widget for "Other" Gender Input
class genderTextInput extends StatelessWidget {
  final TextEditingController controller;

  genderTextInput(this.controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      // Input Gender for "Other"
      children: [
        Expanded(
            flex: 2,
            child: Column(children: [
              Text(
                ' ',
                style: TextStyle(color: Colors.blue, fontSize: 17.0),
              ),
            ])),
        Expanded(
            flex: 8,
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  // Type in Other Gender
                  width: 400,
                  child: TextField(
                      enabled: true,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Please type in your gender',
                        hintStyle:
                            TextStyle(color: Colors.blue, fontSize: 17.0),
                        fillColor: Colors.black,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                                width: 2.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                                width: 3)),
                      )),
                ),
              )
            ]))
      ],
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
    apiKey: kGoogleApiKey,
    sessionToken: Uuid().generateV4(),
    language: "en",
    components: [Component(Component.country, "uk")],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}