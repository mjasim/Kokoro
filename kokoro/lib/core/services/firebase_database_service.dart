import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kokoro/core/models/post_model.dart';


class FirebaseDatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future createUser({@required uid, @required username, @required email,
                     @required location, name, birthday, gender}) {
    return users.doc(uid).set({
      'username': username,
      'email': email,
      'location': location,
      'name': name,
      'birthday': birthday,
      'gender': gender,
    });
  }

  Future createPost({@required uid, @required username,
                     @required contentType, @required content}) {
    return posts.doc().set({
      'authorUid': uid,
      'authorUsername': username,
      'contentType': contentType,
      'content': content,
      'dateCreated': FieldValue.serverTimestamp(),
    });
  }

  Future<List<PostModel>> getPosts() async {
    QuerySnapshot postSnapshot = await posts.limit(10)
        .orderBy('dateCreated', descending: true)
        .get();

    var random = Random();
    return postSnapshot.docs.map((e) {
      var element = e.data();
      return PostModel(
        authorUid: element['authorUid'],
        authorUsername: element['authorUsername'],
        postText: element['content'],
        dateCreated: element['dateCreated'],
        reactionAverage: random.nextDouble() * 100,
        commentCount: random.nextInt(100),
        reactionColor: generateRandomHexColor(random),
        reactionCount: random.nextInt(100),
        userReactionAmount: 50,
        userSelectedColor: null,
        authorProfilePhotoUrl: 'https://images.generated.photos/0Ok6OTj1BHb-WO_vQAIO6A9VSUVeSdmKTmKZm28FO7E/rs:fit:512:512/wm:0.95:sowe:18:18:0.33/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3Njk5ODUuanBn.jpg',
      );
    }).toList();
  }
}

String generateRandomHexColor(random){
  int length = 6;
  String chars = '0123456789ABCDEF';
  String hex = '#';
  while(length-- > 0) hex += chars[(random.nextInt(16)) | 0];
  return hex;
}