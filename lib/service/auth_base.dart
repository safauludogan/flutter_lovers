import '../model/MyUser.dart';

abstract class AuthBase{

  Future<MyUser?> getCurrentUser();
  Future<MyUser?> signInWithGoogle();
  Future<MyUser?> signInWithAnonymously();
  Future<MyUser?> createUserWithEmailPassword(String email, String password);
  Future<MyUser?> signInWithEmailPassword(String email, String password);
  Future<bool> signOut();

}