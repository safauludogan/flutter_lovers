import 'package:flutter_lovers_app/model/MyUser.dart';

abstract class DatabaseManager{
  Future<bool> saveUser(MyUser user);
  Future<MyUser> readUser(String userID);
  Future<bool> updateUsername(String userID,String newUsername);
  Future<bool> updateProfilePhoto(String userID,String imageUrl);
  Future<List<MyUser>> getAllUsers();
}