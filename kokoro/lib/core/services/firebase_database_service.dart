import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FirebaseDatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

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

  Future createPost({@required uid, @required username, @required contentType, @required content}) {
    return posts.doc().set({
      'uid': uid,
      'username': username,
      'contentType': contentType,
      'content': content,
    });
  }
}