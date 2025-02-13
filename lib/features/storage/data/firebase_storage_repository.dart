import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_social_media/features/storage/domain/storagre_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  /*
  * UPLOAD PROFILE IMAGE
  * */
  //mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  //web platform
  @override
  Future<String?> uploadProfileImageWeb(Uint8List file, String fileName) {
    return _uploadBytes(file, fileName, "profile_images");
  }

  /*
  * POST IMAGE UPLOAD
  * */
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List file, String fileName) {
    return _uploadBytes(file, fileName, "post_images");
  }

//===========
//mobile platforms (file)
  Future<String?> _uploadFile(String path, String fileName, String folder) async {
    try {
      //get file
      final file = File(path);

      //find place to store file
      final storageRef = firebaseStorage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await storageRef.putFile(file);

      //gte image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

//web platforms (bytes)
  Future<String?> _uploadBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {
      //find place to store file
      final storageRef = firebaseStorage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await storageRef.putData(fileBytes);

      //gte image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
