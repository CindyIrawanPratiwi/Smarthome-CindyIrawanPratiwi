// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBeWBxYNgbq2IA65_UYSAhjK279dRW1Qp4',
    appId: '1:537991146168:web:1d6d1a3cf9c1f110b3a24d',
    messagingSenderId: '537991146168',
    projectId: 'smarthome-539fe',
    authDomain: 'smarthome-539fe.firebaseapp.com',
    storageBucket: 'smarthome-539fe.appspot.com',
    measurementId: 'G-6V4P039J94',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHXv-o4K7hFawdR7is-cD8SIvoNNWXqa0',
    appId: '1:537991146168:android:7ef7138699779f36b3a24d',
    messagingSenderId: '537991146168',
    projectId: 'smarthome-539fe',
    storageBucket: 'smarthome-539fe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwMOdsSXBwZEOuWvN0AlYTFneuj-ZKNAQ',
    appId: '1:537991146168:ios:6443c6c0f39959d9b3a24d',
    messagingSenderId: '537991146168',
    projectId: 'smarthome-539fe',
    storageBucket: 'smarthome-539fe.appspot.com',
    iosBundleId: 'com.example.flutterAppSmarthome',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwMOdsSXBwZEOuWvN0AlYTFneuj-ZKNAQ',
    appId: '1:537991146168:ios:2fb31a279b3b2a5bb3a24d',
    messagingSenderId: '537991146168',
    projectId: 'smarthome-539fe',
    storageBucket: 'smarthome-539fe.appspot.com',
    iosBundleId: 'com.example.flutterAppSmarthome.RunnerTests',
  );
}
