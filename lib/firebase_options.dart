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
    apiKey: 'AIzaSyAx0PwSJpQTeYaLYF6T91XrrbdBvzJ0pe4',
    appId: '1:577891758892:web:abe52a530ff6ef7c793289',
    messagingSenderId: '577891758892',
    projectId: 'newsapp-dc6ab',
    authDomain: 'newsapp-dc6ab.firebaseapp.com',
    storageBucket: 'newsapp-dc6ab.appspot.com',
    measurementId: 'G-84MS30VWYD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDS98EAxRQeSsCxOcH_fM8Y6nTqGiSfgM',
    appId: '1:577891758892:android:082bae44fd1e56ed793289',
    messagingSenderId: '577891758892',
    projectId: 'newsapp-dc6ab',
    storageBucket: 'newsapp-dc6ab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2Ar7rPp5LCqlVloPRj3kHqqFe98B45NI',
    appId: '1:577891758892:ios:bb5b25cb00074595793289',
    messagingSenderId: '577891758892',
    projectId: 'newsapp-dc6ab',
    storageBucket: 'newsapp-dc6ab.appspot.com',
    iosBundleId: 'com.example.newsapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2Ar7rPp5LCqlVloPRj3kHqqFe98B45NI',
    appId: '1:577891758892:ios:bb5b25cb00074595793289',
    messagingSenderId: '577891758892',
    projectId: 'newsapp-dc6ab',
    storageBucket: 'newsapp-dc6ab.appspot.com',
    iosBundleId: 'com.example.newsapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAx0PwSJpQTeYaLYF6T91XrrbdBvzJ0pe4',
    appId: '1:577891758892:web:f7e1ec3bbb6ce4d7793289',
    messagingSenderId: '577891758892',
    projectId: 'newsapp-dc6ab',
    authDomain: 'newsapp-dc6ab.firebaseapp.com',
    storageBucket: 'newsapp-dc6ab.appspot.com',
    measurementId: 'G-PHB9MPHQC0',
  );
}