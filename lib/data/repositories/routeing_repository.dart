import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:traffic_congestion/data/network/api/routeing_api.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/utils/extension.dart';

class RouteingRepository {
  final RouteingApi _routeingApi;
  RouteingRepository(this._routeingApi);

  Future<Result> getRouteBetweenCoordinates(LatLng start, LatLng end) async{
    try {

      final response = await _routeingApi.getRouteBetweenCoordinates(start.latitude, start.longitude, end.latitude, end.longitude);

      List<LatLng> coordinates = List.of(List.of(jsonDecode(response.body)["route"]["legs"]).get(0)["maneuvers"])
          .map((e) => LatLng(e["startPoint"]["lat"], e["startPoint"]["lng"]))
          .toList();
      return Success(coordinates);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result> search(String word) async{
    try {
      List<String> list=['Item 1', 'Item 2', 'Item 3', 'Item 4'];
      // final response = await _routeingApi.search(word);
      //
      // if(response.statusCode==200){
      //   list=jsonDecode(response.body);
      // }
      return Success(list);
    } catch (e) {
      return Error(e.toString());
    }
  }

}
