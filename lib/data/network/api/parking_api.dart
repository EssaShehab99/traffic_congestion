import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traffic_congestion/data/models/parking.dart';

import 'package:traffic_congestion/data/models/route.dart';
import 'package:traffic_congestion/data/network/api/constants/endpoint.dart';

class ParkingApi {
  final  _firestore = FirebaseFirestore.instance.collection(Collection.parking);

  Future<DocumentSnapshot<Object?>?> getParking(String parkingID) async {
    try {
      final DocumentSnapshot parkingDoc = await _firestore.doc(parkingID).get();

      if (parkingDoc.exists) {
        return parkingDoc;
      } else {
        return null;
      }
    } catch (e) {
    rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllParking() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore.get();

      return querySnapshot.docs;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertParking(Parking parking) async {
    try {
      await _firestore.add(parking.toMap());
    } catch (e) {
      throw Exception('Failed to insert route: $e');
    }
  }
  Future<void> updateParking(Parking parking) async {
    try {
      await _firestore.doc(parking.id).update(parking.toMap());
    } catch (e) {
      throw Exception('Failed to insert route: $e');
    }
  }
}
