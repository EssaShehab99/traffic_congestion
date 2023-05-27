
import 'package:traffic_congestion/data/network/api/routing_api.dart';
import 'package:traffic_congestion/data/repositories/parking_repository.dart';
import 'package:traffic_congestion/data/repositories/routing_repository.dart';

import '../network/api/parking_api.dart';
import '/data/network/api/auth_api.dart';
import '/data/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(AuthApi());
  getIt.registerSingleton(RoutingApi());
  getIt.registerSingleton(ParkingApi());
  getIt.registerSingleton(AuthRepository(getIt.get<AuthApi>()));
  getIt.registerSingleton(RoutingRepository(getIt.get<RoutingApi>()));
  getIt.registerSingleton(ParkingRepository(getIt.get<ParkingApi>()));

}