import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class RouteingApi {
  Future<Response> getRouteBetweenCoordinates(double startLatitude,double startLongitude,double endLatitude,double endLongitude) async {
    Response response = await get(Uri.parse(
        "http://www.mapquestapi.com/directions/v2/route?key=Ex7UsYmSc7OBavM7L2asxSxVfM2NX2A0&from=$startLatitude,$startLongitude&to=$endLatitude,$endLongitude"));
    return response;
  }
  Future<Response> search(String word) async {
    Response response = await get(Uri.parse('www.google.com?q=$word'));
    return response;
  }


}
