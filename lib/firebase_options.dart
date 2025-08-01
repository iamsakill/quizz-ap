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
    apiKey: 'AIzaSyCpqHWdURdL6O5M-ymVl06vyeNIuADTCYU',
    appId: '1:781321138672:web:8fa15c4594a72db22ced35',
    messagingSenderId: '781321138672',
    projectId: 'quizzapp-b581f',
    authDomain: 'quizzapp-b581f.firebaseapp.com',
    storageBucket: 'quizzapp-b581f.firebasestorage.app',
    measurementId: 'G-WVS56X8NYN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO9Ck38wvBco8HM8CpjeU34xknZ9oEG1U',
    appId: '1:781321138672:android:ad1a77971e8977832ced35',
    messagingSenderId: '781321138672',
    projectId: 'quizzapp-b581f',
    storageBucket: 'quizzapp-b581f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNMN2RwO-GQAw241jgEVgf2BrNhIiyzGo',
    appId: '1:781321138672:ios:219c0328d524107a2ced35',
    messagingSenderId: '781321138672',
    projectId: 'quizzapp-b581f',
    storageBucket: 'quizzapp-b581f.firebasestorage.app',
    iosClientId: '781321138672-793vc5o1ec9gf4mola0cl3nfrqvufpuf.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizzMe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNMN2RwO-GQAw241jgEVgf2BrNhIiyzGo',
    appId: '1:781321138672:ios:219c0328d524107a2ced35',
    messagingSenderId: '781321138672',
    projectId: 'quizzapp-b581f',
    storageBucket: 'quizzapp-b581f.firebasestorage.app',
    iosClientId: '781321138672-793vc5o1ec9gf4mola0cl3nfrqvufpuf.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizzMe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCpqHWdURdL6O5M-ymVl06vyeNIuADTCYU',
    appId: '1:781321138672:web:261b7913d69b9d1b2ced35',
    messagingSenderId: '781321138672',
    projectId: 'quizzapp-b581f',
    authDomain: 'quizzapp-b581f.firebaseapp.com',
    storageBucket: 'quizzapp-b581f.firebasestorage.app',
    measurementId: 'G-N2G4YFY49G',
  );
}
