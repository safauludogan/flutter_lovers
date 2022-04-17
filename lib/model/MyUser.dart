import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String userID;
  String email;
  String? userName;
  String? profileUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  MyUser({required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName':
          userName ?? email.substring(0, email.indexOf('@')) + randomUid(),
      'profileUrl': profileUrl ??
          'https://pbs.twimg.com/profile_images/955579664008908801/07Alu7I8_400x400.jpg',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profileUrl = map['profileUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate();

  String randomUid() {
    int random = Random().nextInt(999999);
    return random.toString();
  }

  @override
  String toString() {
    return 'MyUser{userID: $userID, email: $email, userName: $userName, profileUrl: $profileUrl, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
