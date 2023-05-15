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
  final destination = const LatLng(15.341587817873876, 44.16920211343145);
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
    for (var route in routes) {
      PolylineId id = PolylineId(route.hashCode.toString());
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: route.route,
        width: 3,
      );
      polylines[id] = polyline;
    }
  }
}
