import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  Future<void> insertRouting(String email, List<LatLng> route, DateTime startDateTime, DateTime endDateTime) async {
    try {
 debugPrint('=============RoutingRepository->insertRouting===================');
      await _routingApi.insertRoute(email, route, startDateTime, endDateTime);
    } catch (e) {
      throw Exception('Failed to insert routing: $e');
    }
  }

  Future<List<List<LatLng>>> getAllUsersRoutes(String email,
      DateTime startDateTime, DateTime endDateTime) async {
    try {
      List<QueryDocumentSnapshot> data =
          await _routingApi.getAllRoutes(startDateTime, endDateTime);

      List<List<LatLng>> allRoutes = [];

      for (QueryDocumentSnapshot snapshot in data) {
        if(snapshot.get('email')==email) continue;
        List<dynamic> routeData = snapshot.get('route');
        List<LatLng> route = routeData.map((data) {
          double lat = data['lat'];
          double lng = data['lng'];
          return LatLng(lat, lng);
        }).toList();

        allRoutes.add(route);
      }

      return allRoutes;
    } catch (e) {
      throw Exception('Failed to retrieve routes: $e');
    }
  }
}
