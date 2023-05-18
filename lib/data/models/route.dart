import 'dart:ui' show Color;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  int id;
  List<LatLng> route;
  int travelTime;
  Color color;
  bool isSelected;
  String distance;
  RouteModel({required this.id, required this.route, required this.travelTime,required this.color,required this.distance,this.isSelected=false});
}
