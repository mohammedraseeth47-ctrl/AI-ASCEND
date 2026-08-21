import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKaUdZlsOI0eIip0bmZ3OgOgKFwgRnznI',
    appId: '1:311753829894:android:01ecf32244fa601ced5d87',
    messagingSenderId: '311753829894',
    projectId: 'trackgo-d8fc1',
    storageBucket: 'trackgo-d8fc1.firebasestorage.app',
    databaseURL:
        'https://trackgo-d8fc1-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
}
