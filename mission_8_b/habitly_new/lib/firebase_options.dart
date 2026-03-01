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
    apiKey: 'AIzaSyBfqZnhpCKEpmjTtNGWZjX5abslc2epKmk',
    appId: '1:1005514853721:web:c45fc26c0cc3a703eed048',
    messagingSenderId: '1005514853721',
    projectId: 'habitly-app-fc8ec',
    authDomain: 'habitly-app-fc8ec.firebaseapp.com',
    storageBucket: 'habitly-app-fc8ec.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5W6v6nnDIYjOPuUaE_EuL_B8qf5Jpvp0',
    appId: '1:1005514853721:android:d14c4926e4301bf9eed048',
    messagingSenderId: '1005514853721',
    projectId: 'habitly-app-fc8ec',
    storageBucket: 'habitly-app-fc8ec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUZxilszoU-S7sUAMV0ROki5_sfzu3aKo',
    appId: '1:1005514853721:ios:81fcc82ad32d81e4eed048',
    messagingSenderId: '1005514853721',
    projectId: 'habitly-app-fc8ec',
    storageBucket: 'habitly-app-fc8ec.firebasestorage.app',
    iosBundleId: 'com.example.habitly',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUZxilszoU-S7sUAMV0ROki5_sfzu3aKo',
    appId: '1:1005514853721:ios:81fcc82ad32d81e4eed048',
    messagingSenderId: '1005514853721',
    projectId: 'habitly-app-fc8ec',
    storageBucket: 'habitly-app-fc8ec.firebasestorage.app',
    iosBundleId: 'com.example.habitly',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBfqZnhpCKEpmjTtNGWZjX5abslc2epKmk',
    appId: '1:1005514853721:web:034b53f2e8c18eabeed048',
    messagingSenderId: '1005514853721',
    projectId: 'habitly-app-fc8ec',
    authDomain: 'habitly-app-fc8ec.firebaseapp.com',
    storageBucket: 'habitly-app-fc8ec.firebasestorage.app',
  );

}