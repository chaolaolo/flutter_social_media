// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBkeKaKYtBQExIltQtc3aHfCeBiL2C1hy8',
    appId: '1:339270898842:web:22df0bbde9d19220b2fb23',
    messagingSenderId: '339270898842',
    projectId: 'cro102-2be94',
    authDomain: 'cro102-2be94.firebaseapp.com',
    storageBucket: 'cro102-2be94.appspot.com',
    measurementId: 'G-XGJ8FJ6GSR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCF0_zA7MfAmDjoKhH1qTiyPa7H0qdknmk',
    appId: '1:339270898842:android:7ad486cb7842b903b2fb23',
    messagingSenderId: '339270898842',
    projectId: 'cro102-2be94',
    storageBucket: 'cro102-2be94.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjkCtL4ajvqRiXZGFRlrId0-lUr23hZ0w',
    appId: '1:339270898842:ios:453c5ff92ff3c58bb2fb23',
    messagingSenderId: '339270898842',
    projectId: 'cro102-2be94',
    storageBucket: 'cro102-2be94.appspot.com',
    androidClientId: '339270898842-211vi2f81so8n8gcqej6m85ggqvihple.apps.googleusercontent.com',
    iosClientId: '339270898842-2uc2s0ve8eju4v01spb038ea3cuiv77k.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterSocialMedia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjkCtL4ajvqRiXZGFRlrId0-lUr23hZ0w',
    appId: '1:339270898842:ios:453c5ff92ff3c58bb2fb23',
    messagingSenderId: '339270898842',
    projectId: 'cro102-2be94',
    storageBucket: 'cro102-2be94.appspot.com',
    androidClientId: '339270898842-211vi2f81so8n8gcqej6m85ggqvihple.apps.googleusercontent.com',
    iosClientId: '339270898842-2uc2s0ve8eju4v01spb038ea3cuiv77k.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterSocialMedia',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBkeKaKYtBQExIltQtc3aHfCeBiL2C1hy8',
    appId: '1:339270898842:web:185312188e5361a6b2fb23',
    messagingSenderId: '339270898842',
    projectId: 'cro102-2be94',
    authDomain: 'cro102-2be94.firebaseapp.com',
    storageBucket: 'cro102-2be94.appspot.com',
    measurementId: 'G-7D84L4YKC0',
  );
}
