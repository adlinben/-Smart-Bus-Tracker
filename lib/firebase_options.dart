import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC9BOvxPlp9DJTDctVeSkr2YWmpbQ70iMc',
    appId: '1:170672521014:web:61dd59e4afb10853a77d97',
    messagingSenderId: '170672521014',
    projectId: 'smart-bus-tracker-a2e2f',
    authDomain: 'smart-bus-tracker-a2e2f.firebaseapp.com',
    storageBucket: 'smart-bus-tracker-a2e2f.firebasestorage.app',
    measurementId: 'G-8T86H31Y8G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBygXJJOqrYwTM6NtEsJEKdxOUcTAg2ek',
    appId: '1:170672521014:android:56942fb163534783a77d97',
    messagingSenderId: '170672521014',
    projectId: 'smart-bus-tracker-a2e2f',
    storageBucket: 'smart-bus-tracker-a2e2f.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvT_BTP3YzkPDDmQG4u1VYeJiGBqh94BY',
    appId: '1:170672521014:ios:1ca9ad511be4b6a7a77d97',
    messagingSenderId: '170672521014',
    projectId: 'smart-bus-tracker-a2e2f',
    storageBucket: 'smart-bus-tracker-a2e2f.firebasestorage.app',
    iosBundleId: 'com.example.smartbusTrackerNew',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCvT_BTP3YzkPDDmQG4u1VYeJiGBqh94BY',
    appId: '1:170672521014:ios:1ca9ad511be4b6a7a77d97',
    messagingSenderId: '170672521014',
    projectId: 'smart-bus-tracker-a2e2f',
    storageBucket: 'smart-bus-tracker-a2e2f.firebasestorage.app',
    iosBundleId: 'com.example.smartbusTrackerNew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC9BOvxPlp9DJTDctVeSkr2YWmpbQ70iMc',
    appId: '1:170672521014:web:bdb5ba29079e8b36a77d97',
    messagingSenderId: '170672521014',
    projectId: 'smart-bus-tracker-a2e2f',
    authDomain: 'smart-bus-tracker-a2e2f.firebaseapp.com',
    storageBucket: 'smart-bus-tracker-a2e2f.firebasestorage.app',
    measurementId: 'G-3FZEL6WXM4',
  );
}
