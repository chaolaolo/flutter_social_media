import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/app.dart';
import 'package:flutter_social_media/config/firebase_options.dart';

Future<void> main() async {
  //firebase set up
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //run app
  runApp(MyApp());
}
