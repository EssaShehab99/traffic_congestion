import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:traffic_congestion/data/network/api/constants/endpoint.dart';
import 'package:traffic_congestion/data/utils/extension.dart';

class AuthApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String?> register(Map<String, dynamic> body) async {
    try {
      DocumentReference documentRef =
      await _fireStore.collection(Collection.users).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> login(
      String email, String password) async {
    try {
      final response = await _fireStore
          .collection(Collection.users)
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();
      return response.docs.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> checkUser(String email) async {
    try {
      final response = await _fireStore
          .collection(Collection.users)
          .where("email", isEqualTo: email)
          .get();
      return response.docs.firstOrNull;
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> changePassword(String email,Map<String, dynamic> body) async {
    try {
      final response=  await _fireStore
          .collection(Collection.users)
          .where("email", isEqualTo: email)
          .get();
      await _fireStore
          .collection(Collection.users).doc(response.docs.firstOrNull?.id).update(body);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
