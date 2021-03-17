import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

class FirebaseStorageService {
  firebase_storage.FirebaseStorage profilePhotoBucket =
      firebase_storage.FirebaseStorage.instanceFor(bucket: 'profile-photos');

  firebase_storage.FirebaseStorage postPhotoBucket =
      firebase_storage.FirebaseStorage.instanceFor(bucket: 'post-photos');

  Future<void> uploadProfilePhoto({@required String filePath, @required fileName}) {
    File file = File(filePath);
    return profilePhotoBucket.ref('$fileName.png').putFile(file);
  }
}
