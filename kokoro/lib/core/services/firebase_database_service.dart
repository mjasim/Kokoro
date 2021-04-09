import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kokoro/core/models/comment_model.dart';
import 'package:kokoro/core/models/post_model.dart';

class FirebaseDatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference comments =
      FirebaseFirestore.instance.collection('comments');
  CollectionReference sliderReact =
      FirebaseFirestore.instance.collection('slider-reactions');
  CollectionReference colorReact =
      FirebaseFirestore.instance.collection('color-reactions');

  Future createUser(
      {@required uid,
      @required username,
      @required email,
      @required location,
      name,
      birthday,
      gender}) {
    return users.doc(uid).set({
      'username': username,
      'email': email,
      'location': location,
      'name': name,
      'birthday': birthday,
      'gender': gender,
    });
  }

  Future<String> getUsername({@required uid}) async {
    DocumentReference docRef = users.doc(uid);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      print('Document exists');
      return doc.data()['username'];
    } else {
      return null;
    }
  }

  Future createPost(
      {@required uid,
      @required username,
      @required contentType,
      @required postText,
      contentUrl}) {
    return posts.doc().set({
      'authorUid': uid,
      'authorProfilePhotoUrl':
          'https://images.generated.photos/0Ok6OTj1BHb-WO_vQAIO6A9VSUVeSdmKTmKZm28FO7E/rs:fit:512:512/wm:0.95:sowe:18:18:0.33/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3Njk5ODUuanBn.jpg',
      'authorUsername': username,
      'contentType': contentType,
      'contentUrl': contentUrl,
      'postText': postText,
      'sliderReactionCount': 0,
      'sumOfSliderReactions': 0,
      'colorReactionCount': 0,
      'sumOfHueColorValue': 0,
      'sumOfSaturationColorValue': 0,
      'sumOfLightnessColorValue': 0,
      'planets': [],
      'commentCount': 0,
      'dateCreated': FieldValue.serverTimestamp(),
    });
  }

  Future createComment(
      {@required uid,
      @required username,
      @required commentText,
      @required profilePhotoUrl,
      @required postUid,
      @required postAuthorUid}) {
    posts.doc(postUid).update({'commentCount': FieldValue.increment(1)});

    return comments.doc().set({
      'authorUid': uid,
      'postUid': postUid,
      'authorProfilePhotoUrl': profilePhotoUrl,
      'authorUsername': username,
      'commentText': commentText,
      'postAuthorUid': postAuthorUid,
      'dateCreated': FieldValue.serverTimestamp(),
    });
  }

  Future createSliderReact({
    @required uid,
    @required postUid,
    @required postAuthorUid,
    @required sliderValue,
  }) {
    posts.doc(postUid).update({'sliderReactionCount': FieldValue.increment(1)});
    posts
        .doc(postUid)
        .update({'sumOfSliderReactions': FieldValue.increment(sliderValue)});

    return sliderReact.doc().set({
      'reactorUid': uid,
      'postUid': postUid,
      'postAuthorUid': postAuthorUid,
      'sliderValue': sliderValue,
      'dateCreated': FieldValue.serverTimestamp(),
    });
  }

  Future createColorReact({
    @required uid,
    @required postUid,
    @required postAuthorUid,
    @required hueValue,
    @required saturationValue,
    @required lightnessValue,
    @required postType,
    alphaValue,
  }) {
    posts.doc(postUid).update({'colorReactionCount': FieldValue.increment(1)});
    posts.doc(postUid).update({
      'sumOfHueColorValue': FieldValue.increment(hueValue),
      'sumOfSaturationColorValue': FieldValue.increment(saturationValue),
      'sumOfLightnessColorValue': FieldValue.increment(lightnessValue),
    });

    return sliderReact.doc().set({
      'reactorUid': uid,
      'postUid': postUid,
      'postAuthorUid': postAuthorUid,
      'postType': postType,
      'hueValue': hueValue,
      'saturationValue': saturationValue,
      'lightnessValue': lightnessValue,
      'dateCreated': FieldValue.serverTimestamp(),
    });
  }

  Future updateSliderReact({
    @required uid,
    @required postUid,
    @required sliderValue,
  }) async {
    QuerySnapshot sliderSnapshot = await sliderReact
        .limit(1)
        .where('postUid', isEqualTo: postUid)
        .where('reactorUid', isEqualTo: uid)
        .get();

    if (sliderSnapshot.docs.isEmpty) {
      return null;
    }

    double previousSliderValue =
        sliderSnapshot.docs.first.data()['sliderValue'];
    posts.doc(postUid).update({
      'sumOfSliderReactions':
          FieldValue.increment(sliderValue - previousSliderValue)
    });

    return sliderReact.doc(sliderSnapshot.docs.first.id).update({
      'sliderValue': sliderValue,
    });
  }

  Future updateColorReact({
    @required uid,
    @required postUid,
    @required hueValue,
    @required saturationValue,
    @required lightnessValue,
  }) async {
    QuerySnapshot sliderSnapshot = await sliderReact
        .limit(1)
        .where('postUid', isEqualTo: postUid)
        .where('reactorUid', isEqualTo: uid)
        .get();

    if (sliderSnapshot.docs.isEmpty) {
      return null;
    }

    double previousHueValue =
    sliderSnapshot.docs.first.data()['hueValue'];
    double previousSaturationValue =
    sliderSnapshot.docs.first.data()['saturationValue'];
    double previousLightnessValue =
    sliderSnapshot.docs.first.data()['lightnessValue'];
    posts.doc(postUid).update({
      'sumOfHueColorValue': FieldValue.increment(hueValue - previousHueValue),
      'sumOfSaturationColorValue': FieldValue.increment(saturationValue - previousSaturationValue),
      'sumOfLightnessColorValue': FieldValue.increment(lightnessValue - previousLightnessValue),
    });

    return sliderReact.doc(sliderSnapshot.docs.first.id).update({
      'hueValue': hueValue,
      'saturationValue': saturationValue,
      'lightnessValue': lightnessValue,
    });
  }

  Future<double> getUserSliderReactionAmount(
      {@required postUid, @required reactorUid}) async {
    QuerySnapshot sliderSnapshot = await sliderReact
        .limit(1)
        .where('postUid', isEqualTo: postUid)
        .where('reactorUid', isEqualTo: reactorUid)
        .get();

    if (sliderSnapshot.docs.isEmpty) {
      return null;
    }

    QueryDocumentSnapshot docSnapshot = sliderSnapshot.docs.first;
    return docSnapshot.data()['sliderValue'];
  }

  Future<dynamic> getUserColorReactionValue(
      {@required postUid, @required reactorUid}) async {
    QuerySnapshot colorSnapshot = await colorReact
        .limit(1)
        .where('postUid', isEqualTo: postUid)
        .where('reactorUid', isEqualTo: reactorUid)
        .get();

    if (colorSnapshot.docs.isEmpty) {
      return null;
    }

    QueryDocumentSnapshot docSnapshot = colorSnapshot.docs.first;
    Map data = docSnapshot.data();
    return {
      'hue': data['hue'],
      'lightness': data['lightness'],
      'saturation': data['saturation'],
      'alpha': data['alpha'],
    };
  }

  Future<List<PostModel>> getPosts() async {
    QuerySnapshot postSnapshot =
        await posts.limit(20).orderBy('dateCreated', descending: true).get();

    var random = Random();
    return postSnapshot.docs.map((e) {
      var element = e.data();
      return PostModel(
        postUid: e.id,
        authorUid: element['authorUid'],
        authorUsername: element['authorUsername'],
        postText: element['postText'],
        dateCreated: element['dateCreated'],
        contentType: element['contentType'],
        contentUrl: element['contentUrl'],
        commentCount: element['commentCount'],
        planets: element['planets'],
        sumOfHueColorValue: element['sumOfHueColorValue'],
        sumOfLightnessColorValue: element['sumOfLightnessColorValue'],
        sumOfSaturationColorValue: element['sumOfSaturationColorValue'],
        sliderReactionCount: element['sliderReactionCount'],
        sumOfSliderReactions: element['sumOfSliderReactions'],
        colorReactionCount: element['colorReactionCount'],
        commentsOpen: false,
        userReactionAmount: 0,
        userSelectedColor: null,
        authorProfilePhotoUrl:
            'https://images.generated.photos/0Ok6OTj1BHb-WO_vQAIO6A9VSUVeSdmKTmKZm28FO7E/rs:fit:512:512/wm:0.95:sowe:18:18:0.33/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3Njk5ODUuanBn.jpg',
      );
    }).toList();
  }

  Future<List<CommentModel>> getComments(postUid) async {
    QuerySnapshot commentSnapshot = await comments
        .limit(4)
        .orderBy('dateCreated', descending: true)
        .where('postUid', isEqualTo: postUid)
        .get();

    return commentSnapshot.docs.map((e) {
      var element = e.data();
      return CommentModel(
        commentText: element['commentText'],
        username: element['authorUsername'],
        postAuthorUid: element['postAuthorUid'],
        postUid: element['postUid'],
        authorUid: element['authorUid'],
        authorProfilePhotoUrl:
            'https://images.generated.photos/0Ok6OTj1BHb-WO_vQAIO6A9VSUVeSdmKTmKZm28FO7E/rs:fit:512:512/wm:0.95:sowe:18:18:0.33/Z3M6Ly9nZW5lcmF0/ZWQtcGhvdG9zL3Yz/XzA3Njk5ODUuanBn.jpg',
      );
    }).toList();
  }
}

String generateRandomHexColor(random) {
  int length = 6;
  String chars = '0123456789ABCDEF';
  String hex = '#';
  while (length-- > 0) hex += chars[(random.nextInt(16)) | 0];
  return hex;
}
