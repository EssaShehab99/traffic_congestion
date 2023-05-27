import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:traffic_congestion/data/di/service_locator.dart';
import 'package:traffic_congestion/data/models/route.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/repositories/parking_repository.dart';
import 'package:traffic_congestion/data/repositories/routing_repository.dart';
import 'package:traffic_congestion/data/usecases/user_crossing_usecase.dart';

import '../models/parking.dart';
import '../utils/initial_notifications.dart';
import '/data/models/user.dart';
import 'package:collection/collection.dart';

class ParkingProvider extends ChangeNotifier {
  ParkingProvider(this._user);
  final User? _user;
  final _parkingRepository =  getIt.get<ParkingRepository>();
  List<List<Parking>> groupParking = [];
  DateTime? from;
  DateTime? to;

  Future<void> getAllParking() async {
    Result result = await _parkingRepository.getAllParking();
    if (result is Success) {
      List<Parking> allParking = result.value as List<Parking>;
      groupParking = [
        allParking.where((element) => element.group == 'A').toList()..sort((a, b) => a.order.compareTo(b.order)),
        allParking.where((element) => element.group == 'B').toList()..sort((a, b) => a.order.compareTo(b.order))
      ];
    }
  }

  Future<void> insertParking(Parking parking) async {
    await _parkingRepository.insertParking(parking);
  }
  Future<Result> reservedParking(Parking parking) async {
    if(parking.wasTaken==true)return NotValid();
    parking.from=from;
    parking.to=to;
    Result result =await _parkingRepository.updateParking(parking);
    groupParking=[...groupParking];
    parking.wasTaken=parking.from?.isBefore(DateTime.now()) == true && parking.to?.isAfter(DateTime.now()) == true;
    notifyListeners();
   return result;
  }


}
