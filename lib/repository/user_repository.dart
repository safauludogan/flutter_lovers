import 'dart:io';

import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:flutter_lovers_app/service/auth_base.dart';
import 'package:flutter_lovers_app/service/firebase_auth_service.dart';
import 'package:flutter_lovers_app/service/firebase_storage_service.dart';
import 'package:flutter_lovers_app/utils/locator.dart';
import '../service/FakeAuthService.dart';
import '../service/firebase_database_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDatabaseService _firestoreDatabaseService =
      locator<FirestoreDatabaseService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<MyUser?> createUserWithEmailPassword(
      String email, String password) async {
    if (appMode == AppMode.RELEASE) {
      MyUser? myUser = await _firebaseAuthService.createUserWithEmailPassword(
          email, password);

      if (myUser != null) {
        bool result = await _firestoreDatabaseService.saveUser(myUser);
        if (result) {
          return await _firestoreDatabaseService.readUser(myUser.userID);
        }
      }
      return null;
    } else {
      return await _fakeAuthService.createUserWithEmailPassword(
          email, password);
    }
  }

  @override
  Future<MyUser?> signInWithEmailPassword(String email, String password) async {
    if (appMode == AppMode.RELEASE) {
      MyUser? myUser =
          await _firebaseAuthService.signInWithEmailPassword(email, password);

      if (myUser != null) {
        return await _firestoreDatabaseService.readUser(myUser.userID);
      }
      return null;
    } else {
      return await _fakeAuthService.signInWithEmailPassword(email, password);
    }
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    if (appMode == AppMode.RELEASE) {
      MyUser? myUser = await _firebaseAuthService.getCurrentUser();

      if (myUser != null) {
        return await _firestoreDatabaseService.readUser(myUser.userID);
      }
      return null;
    } else {
      return _fakeAuthService.getCurrentUser();
    }
  }

  @override
  Future<MyUser?> signInWithAnonymously() async {
    if (appMode == AppMode.RELEASE) {
      MyUser? myUser = await _firebaseAuthService.signInWithAnonymously();
      return myUser;
    } else {
      return _fakeAuthService.signInWithAnonymously();
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    if (appMode == AppMode.RELEASE) {
      MyUser? myUser = await _firebaseAuthService.signInWithGoogle();

      if (myUser != null) {
        bool result = await _firestoreDatabaseService.saveUser(myUser);

        if (result) {
          return await _firestoreDatabaseService.readUser(myUser.userID);
        }
      }
      await _firebaseAuthService.signOut();
      return null;
    } else {
      return await _fakeAuthService.signInWithGoogle();
    }
  }

  @override
  Future<bool> signOut() {
    if (appMode == AppMode.RELEASE) {
      return _firebaseAuthService.signOut();
    } else {
      return _fakeAuthService.signOut();
    }
  }

  Future<bool> updateUsername(String userID, String newUsername) async {
    if (appMode == AppMode.RELEASE) {
      return await _firestoreDatabaseService.updateUsername(
          userID, newUsername);
    } else {
      return false;
    }
  }

  Future<String> uploadFile(
      String userID, String imageType, File? image) async {
    if (appMode == AppMode.RELEASE) {
      var imageUrl =
          await _firebaseStorageService.upload(userID, imageType, image!);
      await _firestoreDatabaseService.updateProfilePhoto(userID, imageUrl);
      return imageUrl;
    } else {
      return "dosya indirme linki";
    }
  }

  Future<List<MyUser>> getAllUsers() async{
    if (appMode == AppMode.RELEASE) {
      var allUsers = await _firestoreDatabaseService.getAllUsers();
      return allUsers;
    } else {
      return [];
    }
  }
}
