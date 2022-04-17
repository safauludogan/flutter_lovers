import 'package:flutter/cupertino.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:flutter_lovers_app/service/database_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class FirestoreDatabaseService implements DatabaseManager {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser user) async {
    await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());
    return true;
  }

  @override
  Future<MyUser> readUser(String userID) async {
    DocumentSnapshot _readingUser =
        await _firebaseDB.collection("users").doc(userID).get();
    Map<String, dynamic> _readingUserMap =
        _readingUser.data() as Map<String, dynamic>;

    MyUser _readingUserModel = MyUser.fromMap(_readingUserMap);
    return _readingUserModel;
  }

  @override
  Future<bool> updateUsername(String userID, String newUsername) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: newUsername)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .doc(userID)
          .update({'userName': newUsername});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String imageUrl) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({'profileUrl': imageUrl});
    return true;
  }

  @override
  Future<List<MyUser>> getAllUsers() async {
    QuerySnapshot querySnapshot = await _firebaseDB.collection("users").get();
    List<MyUser> allUsers = [];

    // for (DocumentSnapshot user in querySnapshot.docs) {
    //   MyUser _myUser = MyUser.fromMap(user.data() as Map<String, dynamic>);
    //   allUsers.add(_myUser);
    //
    // }
    allUsers = querySnapshot.docs
        .map((users) => MyUser.fromMap(users.data() as Map<String,dynamic>))
        .toList();

    return allUsers;
  }
}
