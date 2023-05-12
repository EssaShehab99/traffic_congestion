
import 'package:traffic_congestion/data/network/api/routeing_api.dart';
import 'package:traffic_congestion/data/repositories/routeing_repository.dart';

import '/data/network/api/auth_api.dart';
import '/data/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(AuthApi());
  getIt.registerSingleton(RouteingApi());
  getIt.registerSingleton(AuthRepository(getIt.get<AuthApi>()));
  getIt.registerSingleton(RouteingRepository(getIt.get<RouteingApi>()));

}