import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  firebase_storage.FirebaseStorage profilePhotoBucket =
  firebase_storage.FirebaseStorage.instanceFor(bucket: 'profile-photos');

  firebase_storage.FirebaseStorage postPhotoBucket =
  firebase_storage.FirebaseStorage.instanceFor(bucket: 'post-photos');

  Future<String> uploadPostPhoto({@required fileName, @required imageData}) async {
    var ref = postPhotoBucket.ref('post-photos/$fileName.png');
    await ref.putData(imageData);
    return ref.getDownloadURL();
  }

  Future<String> uploadProfilePhoto({@required fileName, @required imageData}) async {
    var ref = profilePhotoBucket.ref('profile-photos/$fileName.png');
    await ref.putData(imageData);
    return ref.getDownloadURL();
  }

  Future<String> uploadPostVideo({@required fileName, @required videoData}) async {
    var ref = postPhotoBucket.ref('post-videos/$fileName.mp4');
    await ref.putData(videoData, firebase_storage.SettableMetadata(contentType: 'video/mp4'));
    return ref.getDownloadURL();
  }
}