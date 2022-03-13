import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  Future<String> userlogin() async {
    UserCredential userdata = await FirebaseAuth.instance.signInAnonymously();
    return userdata.user!.uid;
  }

  currenUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    return currentUser!.uid;
  }

  Function() get userUid => currenUser;
}
