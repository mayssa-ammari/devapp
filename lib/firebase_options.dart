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
    apiKey: 'AIzaSyCYIG1UQdm0r42Lmy_e0OVXogwVukOf9rM',
    appId: '1:523386495804:web:7db2051e5236573c5f3439',
    messagingSenderId: '523386495804',
    projectId: 'application-gym-deve',
    authDomain: 'application-gym-deve.firebaseapp.com',
    storageBucket: 'application-gym-deve.appspot.com',
    measurementId: 'G-NV9TMN78PT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbb3y700X24EsQixvlh0HGx0WuHrgA9GM',
    appId: '1:523386495804:android:ebb9694902c849b65f3439',
    messagingSenderId: '523386495804',
    projectId: 'application-gym-deve',
    storageBucket: 'application-gym-deve.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDttjuFMzQXFOcDDSidolbFSyH-LlQqJE4',
    appId: '1:523386495804:ios:be4ba74db30ece765f3439',
    messagingSenderId: '523386495804',
    projectId: 'application-gym-deve',
    storageBucket: 'application-gym-deve.appspot.com',
    androidClientId: '523386495804-1tomjnj1b5qop5va64etut7v0h4fbt0t.apps.googleusercontent.com',
    iosClientId: '523386495804-2b1j97ikrc63diknm0fur0a3hnh0khaf.apps.googleusercontent.com',
    iosBundleId: 'com.example.applicationdev',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYIG1UQdm0r42Lmy_e0OVXogwVukOf9rM',
    appId: '1:523386495804:web:e97803e67e6236685f3439',
    messagingSenderId: '523386495804',
    projectId: 'application-gym-deve',
    authDomain: 'application-gym-deve.firebaseapp.com',
    storageBucket: 'application-gym-deve.appspot.com',
    measurementId: 'G-N5E12995YF',
  );

}