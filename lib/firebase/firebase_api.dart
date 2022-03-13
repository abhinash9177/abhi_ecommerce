import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
          apiKey: "AIzaSyCTVaVRxXQ3KuQkxB3MpKPaXEpd0bJQz2U",
          authDomain: "abhi-ecommerce-74054.firebaseapp.com",
          projectId: "abhi-ecommerce-74054",
          storageBucket: "abhi-ecommerce-74054.appspot.com",
          messagingSenderId: "668167511365",
          appId: "1:668167511365:web:bf16c83609f98b3afb722c");
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
          apiKey: "AIzaSyCTVaVRxXQ3KuQkxB3MpKPaXEpd0bJQz2U",
          authDomain: "abhi-ecommerce-74054.firebaseapp.com",
          projectId: "abhi-ecommerce-74054",
          storageBucket: "abhi-ecommerce-74054.appspot.com",
          messagingSenderId: "668167511365",
          appId: "1:668167511365:web:bf16c83609f98b3afb722c");
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:668167511365:web:bf16c83609f98b3afb722c',
        apiKey: 'AIzaSyCTVaVRxXQ3KuQkxB3MpKPaXEpd0bJQz2U',
        projectId: 'abhi-ecommerce-74054',
        messagingSenderId: '668167511365',
      );
    }
  }
}
