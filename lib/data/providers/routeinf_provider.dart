import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_congestion/data/di/service_locator.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/repositories/routeing_repository.dart';

class RouteingProvider extends ChangeNotifier{
  final _routeingRepository = getIt.get<RouteingRepository>();
  List<String> filteredList = [];
  LatLng? endLocation;

  Future<void> filterItems(String searchText) async {
    Result result= await  _routeingRepository.search(searchText);
    if(result is Success){
      filteredList = result.value;
      notifyListeners();
    }
  }
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<List<LatLng>> getRouteBetweenCoordinates(LatLng start, LatLng end) async{
    Result result = await _routeingRepository.getRouteBetweenCoordinates(start, end);
    if (result is Success) {
      return result.value;
    }
    return [];
  }
}