import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_congestion/data/di/service_locator.dart';
import 'package:traffic_congestion/data/models/route.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/repositories/routing_repository.dart';

class RoutingProvider extends ChangeNotifier {
  final _routingRepository = getIt.get<RoutingRepository>();
  final destination = const LatLng(15.334758650591516, 44.19856785305828);
  LatLng? currentLocation;
  List<RouteModel> routes = [];
  Map<PolylineId, Polyline> polylines = {};
  bool isConfirmLocation = false;
  String? arriveAt;
  TimeOfDay? timeOfDay;
  Future<void> determinePosition() async {
    if (currentLocation != null) {
      return;
    }
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
    if (currentLocation == null) {
      return;
    }
    Result result =
        await _routingRepository.getRoutes(currentLocation!, destination);
    if (result is Success) {
      routes = result.value;
      if (routes.isNotEmpty) {
        addPolylines();
        notifyListeners();
      }
    }
  }

  void addPolylines() {
    polylines = {};
    for (var route in routes) {
      PolylineId id = PolylineId(route.hashCode.toString());
      Polyline polyline = Polyline(
        jointType: JointType.round,
        polylineId: id,
        color: route.color,
        points: route.route,
        width: 5,
      );
      polylines[id] = polyline;
    }
  }

  void selectRoute(RouteModel route) {
    isConfirmLocation = true;
    routes.firstWhere((element) => element.isSelected).isSelected = false;
    route.isSelected = true;
    polylines = {};

    PolylineId id = PolylineId(route.hashCode.toString());
    Polyline polyline = Polyline(
      jointType: JointType.round,
      polylineId: id,
      color: route.color,
      points: route.route,
      width: 5,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  void setArriveTime(TimeOfDay? timeOfDay, BuildContext context) {
    if(timeOfDay==null) return;
    this.timeOfDay=timeOfDay;
    final now = TimeOfDay.now();
    final isAfterNow = timeOfDay.hour > now.hour ||
        (timeOfDay.hour == now.hour && timeOfDay.minute >= now.minute);

    if (isAfterNow) {
      final hoursDifference = timeOfDay.hour - now.hour;
      final minutesDifference = timeOfDay.minute - now.minute;

      if (minutesDifference >= 0) {
        arriveAt="You must arrive in $hoursDifference hour(s) and $minutesDifference minute(s)";
      } else {
        final adjustedHours = hoursDifference - 1;
        final adjustedMinutes = 60 + minutesDifference;
        arriveAt="You must arrive in $adjustedHours hour(s) and $adjustedMinutes minute(s)";
      }
    } else {
      arriveAt="You must arrive before ${timeOfDay.format(context)}";
    }
    notifyListeners();
  }


}
