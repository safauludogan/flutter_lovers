import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(userID: user.uid, email: user.email.toString());
  }

  @override
  Future<MyUser?> getCurrentUser() async {
      return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        return _userFromFirebase(result.user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailPassword(
      String email, String password) async {
    return _userFromFirebase((await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password))
        .user);
  }

  @override
  Future<MyUser?> signInWithAnonymously() async {
    UserCredential _userResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(_userResult.user!);
  }

  @override
  Future<MyUser?> signInWithEmailPassword(String email, String password) async {
    UserCredential _userResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(_userResult.user!);
  }

  @override
  Future<bool> signOut() async {
    await _firebaseAuth.signOut();

    final _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();

    return true;
  }
}
