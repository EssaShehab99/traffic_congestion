import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:traffic_congestion/data/network/api/constants/endpoint.dart';
import 'package:traffic_congestion/data/utils/extension.dart';

class AuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesUserExist(String email) async {
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  Future<String?> register(Map<String, dynamic> body) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: body['email'],
        password: body['password'],
      );

      // Save user data in Firestore collection
      String? uid = authResult.user?.uid;
      body['uid'] = uid; // Add UID to user data
      await _firestore.collection('users').doc(uid).set(body);

      return authResult.user?.uid;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Sign in the user with Firebase Authentication
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user data from Firestore
      String uid = authResult.user!.uid;
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(uid).get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData == null) {
        throw FirebaseException(
            code: 'not-found', message: 'User data not found', plugin: '');
      }
      return userData;
    } catch (e) {
      rethrow;
    }
  }


}
