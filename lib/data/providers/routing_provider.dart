import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:traffic_congestion/data/di/service_locator.dart';
import 'package:traffic_congestion/data/models/route.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/repositories/routing_repository.dart';

import '../utils/initial_notifications.dart';

class RoutingProvider extends ChangeNotifier {
  final _routingRepository = getIt.get<RoutingRepository>();
  final destination = const LatLng(26.34887856490672, 43.7667912368093);
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
    Result result = await _routingRepository.getRoutes(
        LatLng(26.318027786127832, 43.806032865990574) /*currentLocation!*/,
        destination);
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

  Future<void> setArriveTime(TimeOfDay? timeOfDay, BuildContext context) async {
    if (timeOfDay == null) return;
    this.timeOfDay = timeOfDay;
    final now = TimeOfDay.now();
    final isAfterNow = timeOfDay.hour > now.hour ||
        (timeOfDay.hour == now.hour && timeOfDay.minute >= now.minute);

    if (isAfterNow) {
      final hoursDifference = timeOfDay.hour - now.hour;
      final minutesDifference = timeOfDay.minute - now.minute;

      if (minutesDifference >= 0) {
        arriveAt =
            "You must arrive in $hoursDifference hour(s) and $minutesDifference minute(s)";
      } else {
        final adjustedHours = hoursDifference - 1;
        final adjustedMinutes = 60 + minutesDifference;
        arriveAt =
            "You must arrive in $adjustedHours hour(s) and $adjustedMinutes minute(s)";
      }
      await scheduleNotification(DateTime.now()
          .add(Duration(hours: hoursDifference, minutes: minutesDifference)),arriveAt);
    } else {
      arriveAt = "You must arrive before ${timeOfDay.format(context)}";
    }
    notifyListeners();
  }

  Future<void> scheduleNotification(
      DateTime timeToArrive, String? message) async {
    if(!timeToArrive.isAfter(DateTime.now())) return;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Set the desired time for the notification
    final DateTime scheduledTime = timeToArrive;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'It\'s time to go out to Qassim University',
      message,
      tz.TZDateTime.from(
          scheduledTime,
          tz.getLocation(
              'America/New_York')), // Date and time to schedule the notification
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
