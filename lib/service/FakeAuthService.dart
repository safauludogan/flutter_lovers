import 'package:flutter_lovers_app/model/MyUser.dart';

import 'auth_base.dart';

class FakeAuthService implements AuthBase{

  @override
  Future<MyUser?> getCurrentUser() async{
   return MyUser(userID: "fakeUserID",email: "fake@email.com");
  }

  @override
  Future<MyUser?> createUserWithEmailPassword(String email, String password) async{
    return await Future.value(MyUser(userID: "created-with-email-id-123456",email: "fake@email.com"));
  }

  @override
  Future<MyUser?> signInWithAnonymously() async{
    return await Future.delayed(const Duration(seconds: 2),() => MyUser(userID: "signed-in-with-anonymously-id-123456",email: "fake@email.com"));
  }

  @override
  Future<MyUser?> signInWithEmailPassword(String email, String password) async{
    return await Future.delayed(const Duration(seconds: 2),() => MyUser(userID: "signed-in-with-email-and-password-id-123456",email: "fake@email.com"));
  }

  @override
  Future<MyUser?> signInWithGoogle() async{
    return await Future.delayed(const Duration(seconds: 2),() => MyUser(userID: "signed-in-with-google-id-123456",email: "fake@email.com"));
  }

  @override
  Future<bool> signOut() async{
    return await Future.value(true);
  }
}
