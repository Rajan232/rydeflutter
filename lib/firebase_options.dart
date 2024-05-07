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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBAai5cvN6NeosRq1coDxLk53aSx8IAVP8',
    appId: '1:789909392459:web:c8cb08122a3822ef1dd1ce',
    messagingSenderId: '789909392459',
    projectId: 'cse3mad-team-all-rounders',
    authDomain: 'cse3mad-team-all-rounders.firebaseapp.com',
    storageBucket: 'cse3mad-team-all-rounders.appspot.com',
    measurementId: 'G-GNGD6LNF2B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtCXevmoGEkYtG2iDv6lEI_lCmgF1gmfg',
    appId: '1:789909392459:android:55945b791445f8ab1dd1ce',
    messagingSenderId: '789909392459',
    projectId: 'cse3mad-team-all-rounders',
    storageBucket: 'cse3mad-team-all-rounders.appspot.com',
  );

}