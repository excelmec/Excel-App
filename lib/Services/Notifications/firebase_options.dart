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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7tbTG9snkcjih4gxw-kwxLynPa6wqCXA',
    appId: '1:694756029811:android:e0e272bf8ddc94a15d8106',
    messagingSenderId: '694756029811',
    projectId: 'excel-services-4dcd1',
    storageBucket: 'excel-services-4dcd1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7ZQiInM77fAmb2QmvXGgR-YW21IE8sMs',
    appId: '1:694756029811:ios:75f457dc1ff90d855d8106',
    messagingSenderId: '694756029811',
    projectId: 'excel-services-4dcd1',
    storageBucket: 'excel-services-4dcd1.appspot.com',
    androidClientId: '694756029811-hu8jhoeqsrba6jqcc5n10th0e2kgtenj.apps.googleusercontent.com',
    iosClientId: '694756029811-3hqpa4agri5bv7jfdm2sd51ad6fi5tut.apps.googleusercontent.com',
    iosBundleId: 'com.example.excel2022',
  );
}
