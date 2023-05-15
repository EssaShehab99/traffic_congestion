import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:traffic_congestion/data/models/route.dart';
import 'package:flutter/services.dart' show rootBundle;

class RoutingApi {

  Future<List<RouteModel>> getRoutes(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    try{
      final alternativeRoutes=await _getMultipleRoutes(startLatitude, startLongitude, endLatitude, endLongitude);
      return alternativeRoutes;
    }catch(e){
      rethrow;
    }
  }

  Future<List<RouteModel>> _getMultipleRoutes(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
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
        String dddd=jsonEncode(data);
        List<dynamic> routes = data["routes"];
        List<RouteModel> routesModels = [];
        // Process each route
        for (var route in routes) {
          String polylinePoints =
              route["overview_polyline"]["points"]; // Encoded polyline points
          int travelTime=route["legs"][0]["duration"]['value'];
          // Decode polyline points to coordinates
          List<LatLng> routeCoordinates = _decodePolyline(polylinePoints);
          routesModels.add(RouteModel(route: routeCoordinates,travelTime: travelTime));
          // Display the coordinates or perform any desired operations
          // print("Route coordinates: $routeCoordinates");
        }
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


}
