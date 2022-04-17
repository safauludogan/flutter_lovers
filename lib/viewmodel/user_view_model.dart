import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:flutter_lovers_app/repository/user_repository.dart';
import 'package:flutter_lovers_app/service/auth_base.dart';

import '../utils/locator.dart';

enum ViewState { IDLE, BUSY }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState viewState = ViewState.IDLE;
  MyUser? myUser;
  String emailErrorMessage = "", passwordErrorMessage = "";
  final UserRepository _userRepository = locator<UserRepository>();

  set state(ViewState value) {
    viewState = value;
    notifyListeners();
  }

  MyUser? get user => myUser;

  ViewState get state => viewState;

  UserViewModel() {
    getCurrentUser();
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    try {
      state = ViewState.BUSY;
      myUser = await _userRepository.getCurrentUser();
      return myUser;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailPassword(
      String email, String password) async {
    if (_emailAndPasswordControl(email, password)) {
      try {
        state = ViewState.BUSY;
        myUser =
            await _userRepository.createUserWithEmailPassword(email, password);
        return myUser;
      } finally {
        state = ViewState.IDLE;
      }
    } else {
      return null;
    }
  }

  bool _emailAndPasswordControl(String email, String password) {
    if (password.length < 6) {
      passwordErrorMessage = "En az 6 karakter olmalı";
      return false;
    } else {
      passwordErrorMessage = "";
    }
    if (!email.contains('@')) {
      emailErrorMessage = "Geçersiz email adresi";
      return false;
    } else {
      emailErrorMessage = "";
    }
    return true;
  }

  Future<List<MyUser>> getAllUsers() async{
    var allUsersList = await _userRepository.getAllUsers();
    return allUsersList;
  }


  @override
  Future<MyUser?> signInWithAnonymously() async {
    try {
      state = ViewState.BUSY;

      myUser = await _userRepository.signInWithAnonymously();
      return myUser;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<MyUser?> signInWithEmailPassword(String email, String password) async {
    try {
      state = ViewState.BUSY;
      myUser = await _userRepository.signInWithEmailPassword(email, password);
      return myUser;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    try {
      state = ViewState.BUSY;

      myUser = await _userRepository.signInWithGoogle();
      return myUser;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.BUSY;
      myUser = null;
      return _userRepository.signOut();
    } finally {
      state = ViewState.IDLE;
    }
  }

  Future<bool> updateUsername(String userID, String newUsername) async {
    return await _userRepository.updateUsername(userID, newUsername);
  }

  Future<String> uploadFile(String userID, String imageType, File? image) async{
    return await _userRepository.uploadFile(userID,imageType,image);
  }

}
