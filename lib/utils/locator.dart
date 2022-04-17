import 'package:flutter_lovers_app/repository/user_repository.dart';
import 'package:flutter_lovers_app/service/firebase_storage_service.dart';
import 'package:get_it/get_it.dart';

import '../service/FakeAuthService.dart';
import '../service/firebase_auth_service.dart';
import '../service/firebase_database_service.dart';

GetIt locator = GetIt.I;

void setLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDatabaseService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}