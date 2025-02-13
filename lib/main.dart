import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/app.dart';
import 'package:flutter_social_media/config/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  //firebase set up
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestStoragePermission();
  //run app
  runApp(MyApp());
}

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}
