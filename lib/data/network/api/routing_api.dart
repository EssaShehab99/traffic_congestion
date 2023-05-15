import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:traffic_congestion/data/models/route.dart';

class RoutingApi {

  Future<List<RouteModel>> getRoutes(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    try{
      List<RouteModel> routes=[];
      final alternativeRoutes=await _getMultipleRoutes(startLatitude, startLongitude, endLatitude, endLongitude);
      for (List<LatLng> route in alternativeRoutes) {
        int travelTime = await getEstimatedTravelTime(route);
        routes.add(RouteModel(route: route,travelTime: travelTime));
      }
      return routes;
    }catch(e){
      rethrow;
    }
  }

  Future<List<List<LatLng>>> _getMultipleRoutes(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    try {
      // Define the origin and destination coordinates
      String origin = "$startLongitude,$startLongitude"; // San Francisco
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
        List<List<LatLng>> routesCoordinates = [];
        // Process each route
        for (var route in routes) {
          String polylinePoints =
              route["overview_polyline"]["points"]; // Encoded polyline points

          // Decode polyline points to coordinates
          List<LatLng> routeCoordinates = _decodePolyline(polylinePoints);
          routesCoordinates.add(routeCoordinates);
          // Display the coordinates or perform any desired operations
          // print("Route coordinates: $routeCoordinates");
        }
        return routesCoordinates;
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

  Future<int> getEstimatedTravelTime(List<LatLng> route) async {
    String apiKey = "AIzaSyCSPglrmqJckRK0vXbJc1TzVR4gfoJmiuE";
    String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";
    String origin = "${route.first.latitude},${route.first.longitude}";
    String destination = "${route.last.latitude},${route.last.longitude}";

    Uri uri = Uri.parse(
        "$baseUrl?origin=$origin&destination=$destination&key=$apiKey&traffic_model=best_guess");

    http.Response response = await http.get(uri);

    Map<String, dynamic> data = json.decode(response.body);

    int travelTime =
        data["routes"][0]["legs"][0]["duration_in_traffic"]["value"];
    return travelTime;
  }
}
