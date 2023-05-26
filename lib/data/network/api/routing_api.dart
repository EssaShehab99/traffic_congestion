import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:traffic_congestion/data/models/route.dart';
import 'package:traffic_congestion/data/network/api/constants/endpoint.dart';

class RoutingApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<RouteModel>> getRoutes(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) async {
    try {
      final alternativeRoutes = await _getMultipleRoutes(
          startLatitude, startLongitude, endLatitude, endLongitude);
      alternativeRoutes.sort((a, b) => a.travelTime.compareTo(b.travelTime));
      return alternativeRoutes;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RouteModel>> _getMultipleRoutes(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) async {
    try {
      // Define the origin and destination coordinates
      String origin = "$startLatitude,$startLongitude"; // San Francisco
      String destination = "$endLatitude,$endLongitude"; // Los Angeles
      // Define your Google Maps API key
      String apiKey = "AIzaSyCSPglrmqJckRK0vXbJc1TzVR4gfoJmiuE";
      // Send HTTP request to the Directions API
      Uri url = Uri.parse(
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey&alternatives=true");

      http.Response response = await http.get(url);

      // Parse the response
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> routes = data["routes"];
        List<RouteModel> routesModels = [];
        // Process each route
        for (var route in routes) {
          String polylinePoints =
              route["overview_polyline"]["points"]; // Encoded polyline points
          int travelTime = route["legs"][0]["duration"]['value'];
          String distance = route["legs"][0]["distance"]['text'];
          // Decode polyline points to coordinates
          List<LatLng> routeCoordinates = _decodePolyline(polylinePoints);
          routesModels.add(RouteModel(
              id: routes.indexOf(route) + 1,
              route: routeCoordinates,
              distance: distance,
              travelTime: travelTime,
              color: Colors.red));
          // Display the coordinates or perform any desired operations
          // print("Route coordinates: $routeCoordinates");
        }
        changeColor(routesModels);
        routesModels
            .reduce((value, element) =>
                value.travelTime < element.travelTime ? value : element)
            .isSelected = true;
        return routesModels;
      } else {
        throw Exception('An Error');
      }
    } catch (e) {
      rethrow;
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1e5, lng / 1e5);
      poly.add(point);
    }

    return poly;
  }

  void changeColor(List<RouteModel> routes) {
    // Find the minimum and maximum travel times
    int minTravelTime =
        routes.map((route) => route.travelTime).reduce((a, b) => a < b ? a : b);
    int maxTravelTime =
        routes.map((route) => route.travelTime).reduce((a, b) => a > b ? a : b);

    // Calculate the color gradient range
    final Color green = Colors.green;
    final Color red = Colors.red;

    for (var route in routes) {
      // Calculate the percentage value based on the travel time within the range
      double percentage =
          (route.travelTime - minTravelTime) / (maxTravelTime - minTravelTime);

      // Interpolate the color between green and red based on the percentage value
      int redComponent =
          ((1 - percentage) * green.red + percentage * red.red).isFinite
              ? ((1 - percentage) * green.red + percentage * red.red).toInt()
              : 0;
      int greenComponent =
          ((1 - percentage) * green.green + percentage * red.green).isFinite
              ? ((1 - percentage) * green.green + percentage * red.green)
                  .toInt()
              : 255;
      int blueComponent =
          ((1 - percentage) * green.blue + percentage * red.blue).isFinite
              ? ((1 - percentage) * green.blue + percentage * red.blue).toInt()
              : 0;

      route.color =
          Color.fromARGB(255, redComponent, greenComponent, blueComponent);
    }
  }

  Future<void> insertRoute(String email, List<LatLng> route,
      DateTime startDateTime, DateTime endDateTime) async {
    try {
      final CollectionReference roadsCollection =
          _firestore.collection(Collection.roads);
      Map<String, dynamic> data = {
        'email': email,
        'route': route
            .map((latLng) => {'lat': latLng.latitude, 'lng': latLng.longitude})
            .toList(),
        'startDateTime': Timestamp.fromDate(startDateTime),
        'endDateTime': Timestamp.fromDate(endDateTime),
      };

      await roadsCollection.doc(email).set(data);
    } catch (e) {
      throw Exception('Failed to insert route: $e');
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllRoutes(
      DateTime startDateTime, DateTime endDateTime) async {
    try {
      final CollectionReference roadsCollection =
          _firestore.collection(Collection.roads);

      final Query query = roadsCollection/*
          .where('startDateTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDateTime))
          .where('startDateTime',
              isLessThanOrEqualTo: Timestamp.fromDate(endDateTime))*/;

      final QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs;
    } catch (e) {
      rethrow;
    }
  }
}
