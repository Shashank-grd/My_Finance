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
    apiKey: 'AIzaSyA_ND01pxaaZ9P12-6IE_otL4A4JoaMGSM',
    appId: '1:1066246299744:web:7cd4e9867f83bba4452305',
    messagingSenderId: '1066246299744',
    projectId: 'finance-baa9c',
    authDomain: 'finance-baa9c.firebaseapp.com',
    storageBucket: 'finance-baa9c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5vlDmO6JaKaWetxCSHJgcympVC_oUSE8',
    appId: '1:1066246299744:android:176ee08ba0de6025452305',
    messagingSenderId: '1066246299744',
    projectId: 'finance-baa9c',
    storageBucket: 'finance-baa9c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqmGrO0GOKes_nirgeTm5NAoLZnRwFeHQ',
    appId: '1:1066246299744:ios:2584192845d4a0e2452305',
    messagingSenderId: '1066246299744',
    projectId: 'finance-baa9c',
    storageBucket: 'finance-baa9c.firebasestorage.app',
    iosBundleId: 'com.example.myfinance',
  );
}
