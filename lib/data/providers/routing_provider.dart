import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_congestion/data/di/service_locator.dart';
import 'package:traffic_congestion/data/models/route.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/repositories/routing_repository.dart';

class RoutingProvider extends ChangeNotifier {
  final _routingRepository = getIt.get<RoutingRepository>();
  final destination = const LatLng(26.34891903376855, 43.7667923667487);
  LatLng? currentLocation;
  List<RouteModel> routes = [];
  Map<PolylineId, Polyline> polylines = {};


  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final position = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(position.latitude, position.longitude);
  }

  Future<void> getRoutes() async {
    if(currentLocation==null){
      return;
    }
    Result result = await _routingRepository.getRoutes(currentLocation!, destination);
    if (result is Success) {
      routes = result.value;
      if(routes.isNotEmpty){
        addPolylines();
        notifyListeners();
      }
    }
  }
  void addPolylines(){
    polylines={};
    // Calculate average travel time
    int totalTravelTime = 0;
    int routeCount = routes.length;
    int routeModelsWithTravelTimeCount = 0;

    for (var routeModel in routes) {
      if (routeModel.travelTime != null) {
        totalTravelTime += routeModel.travelTime!;
        routeModelsWithTravelTimeCount++;
      }
    }

    int averageTravelTime =
    routeModelsWithTravelTimeCount > 0 ? totalTravelTime ~/ routeModelsWithTravelTimeCount : 0;

    // Calculate max travel time difference
    int maxTravelTimeDifference = 0;

    for (var routeModel in routes) {
      if (routeModel.travelTime != null) {
        int difference = (routeModel.travelTime! - averageTravelTime).abs();
        maxTravelTimeDifference = math.max(maxTravelTimeDifference, difference);
      }
    }

    for (var route in routes) {

      Color color;
      if (route.travelTime != null && maxTravelTimeDifference > 0) {
        int difference = route.travelTime! - averageTravelTime;
        double percentage = difference / maxTravelTimeDifference;
        int red = (255 - (percentage * 255)).toInt().clamp(0, 255);
        int green = (percentage * 255).toInt().clamp(0, 255);
        color = Color.fromARGB(255, red, green, 0);
      } else {
        color = Colors.red;
      }


      PolylineId id = PolylineId(route.hashCode.toString());
      Polyline polyline = Polyline(
        polylineId: id,
        color: color,
        points: route.route,
        width: 3,
      );
      polylines[id] = polyline;
    }
  }
}
