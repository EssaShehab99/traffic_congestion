import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlong;

class UserCrossingUseCase {
  static int numberOfUsersCrossing(
      List<List<LatLng>> allUsersRoutes, List<LatLng> myRoute) {
    int count = 0;
    for (var userRoute in allUsersRoutes) {
      double dist = calculateClosestSectionDistance(userRoute, myRoute, 10);
      debugPrint('===============dist: $dist==============');

      if (dist > 3000) count++;
    }
    return count;
  }

  static double calculateClosestSectionDistance(
      List<LatLng> route1, List<LatLng> route2, double distanceThreshold) {
    double minDistance = double.infinity;
    double sectionDistance = 0.0;

    for (int i = 0; i < route1.length - 1; i++) {
      for (int j = 0; j < route2.length - 1; j++) {
        final distance = calculateDistance(route1[i], route2[j]);
        if (distance < minDistance) {
          debugPrint('===============distance: $distance==============');
          minDistance = distance;
          sectionDistance = 0.0;
        }

        if (distance <= distanceThreshold) {
          sectionDistance += calculateDistance(route1[i], route1[i + 1]);
          debugPrint(
              '===============sectionDistance +=: $sectionDistance==============');
        }
      }
    }

    return sectionDistance;
  }

  static double calculateDistance(LatLng point1, LatLng point2) {
    const latlong.Distance distance = latlong.Distance();
    return distance(
      latlong.LatLng(point1.latitude, point1.longitude),
      latlong.LatLng(point2.latitude, point2.longitude),
    );
  }
}
