import 'dart:io';

import 'package:flutter_lovers_app/service/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late Reference _storageReference;

  @override
  Future<String> upload(String userID, String fileType, File image) async {
    var url = "";
    _storageReference = _firebaseStorage.ref().child(userID).child(fileType);
    var uploadTask = _storageReference.putFile(image);

    await uploadTask.whenComplete(() async {
      url = await _storageReference.getDownloadURL();
    });

    return url;
  }
}
