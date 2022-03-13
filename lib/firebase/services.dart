import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AthenticationService {
  final FirebaseAuth firebaseAuth;

  AthenticationService(this.firebaseAuth);

  Future<void> signInAsAnonnymously() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    await createUserData(userCredential.user!.uid);
  }

  Future<void> createUserData(uid) async {
    try {
      var addUserData = FirebaseFirestore.instance.collection('users').doc(uid);
      final json = {'id': addUserData.id, 'date': DateTime.now()};
      await addUserData.set(json);
    } catch (e) {
      print(e);
    }
  }

  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  User? get currentLoggedinUser => firebaseAuth.currentUser;

  User? get currentUserUid {
    var currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  Future<User?> loggenInUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
