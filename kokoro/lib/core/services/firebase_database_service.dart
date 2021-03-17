import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FirebaseDatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future createUser({@required uid, @required username, @required email, @required location, name, birthday, gender}) {
    return users.doc(uid).set({
      'username': username,
      'email': email,
      'location': location,
      'name': name,
      'birthday': birthday,
      'gender': gender,
    });
  }
}