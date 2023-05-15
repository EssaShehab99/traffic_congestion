import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:traffic_congestion/data/network/api/routing_api.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/utils/extension.dart';

class RoutingRepository {
  final RoutingApi _routingApi;
  RoutingRepository(this._routingApi);

  Future<Result> getRoutes(LatLng start, LatLng end) async {
    try {
      final routes = await _routingApi.getRoutes(
          start.latitude, start.longitude, end.latitude, end.longitude);
      return Success(routes);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
