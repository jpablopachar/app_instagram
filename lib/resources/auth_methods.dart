import 'dart:typed_data';

import 'package:app_instagram/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = credential.user!.uid;

        print(credential.user!.uid);
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        await _firestore.collection('users').doc(uid).set({
          'username': username,
          'uid': uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'folllowing': [],
          'photoUrl': photoUrl
        });

        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }
}