import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel{
  List<LatLng> route;
  int? travelTime;

  RouteModel({required this.route, this.travelTime});
}