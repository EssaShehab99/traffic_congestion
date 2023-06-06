import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:traffic_congestion/data/models/parking.dart';
import 'package:traffic_congestion/data/network/api/routing_api.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/utils/extension.dart';

import '../network/api/parking_api.dart';

class ParkingRepository {
  final ParkingApi _parkingApi;
  ParkingRepository(this._parkingApi);

  Future<Result> getParking(
      String parkingID, DateTime from, DateTime to) async {
    try {
      final parkingData = await _parkingApi.getParking(parkingID);
      final parking = Parking.fromJson(
          parkingData?.data() as Map<String, dynamic>, parkingData!.id);
      if (parking.from?.isAfter(from) == true &&
          parking.to?.isBefore(to) == true) {
        return NotValid();
      }
      return Success(parking);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result> getAllParking() async {
    try {
      final parkingData = await _parkingApi.getAllParking();
      final parking = List.of(parkingData)
          .map((e) => Parking.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
      for (var element in parking) {
        element.wasTaken = element.from?.isBefore(DateTime.now()) == true &&
            element.to?.isAfter(DateTime.now()) == true;
      }
      return Success(parking);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result> getCountParking(DateTime from, DateTime to) async {
    try {
      final parkingData = await _parkingApi.getAllParking();
      final parking = List.of(parkingData)
          .map((e) => Parking.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();

      for (var element in parking) {
        DateTime now = DateTime.now();
        element.wasTaken = element.from?.isBefore(now) == true && element.to?.isAfter(now) == true;
        if (isNotInDateTimeRange(now, from, to)) {
          // Perform your desired action if the DateTime is not within the range
          // For example, you can set `wasTaken` to false
          element.wasTaken = false;
        }
      }

      return Success(parking.where((element) => element.wasTaken!=true).length);
    } catch (e) {
      return Error(e.toString());
    }
  }
  bool isNotInDateTimeRange(DateTime dateTime, DateTime from, DateTime to) {
    return dateTime.isBefore(from) || dateTime.isAfter(to);
  }
  Future<void> insertParking(Parking parking) async {
    try {
      debugPrint(
          '=============ParkingRepository->insertParking===================');
      await _parkingApi.insertParking(parking);
    } catch (e) {
      throw Exception('Failed to insert routing: $e');
    }
  }

  Future<Result> updateParking(Parking parking) async {
    try {
      debugPrint(
          '=============ParkingRepository->insertParking===================');
      await _parkingApi.updateParking(parking);
      return Success(parking);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
