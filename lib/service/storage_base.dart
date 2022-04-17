import 'dart:io';

abstract class StorageBase{
  Future<String> upload(String userID,String fileType, File image);
}