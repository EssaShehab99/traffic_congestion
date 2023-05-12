import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/routeinf_provider.dart';

class RouteingMapWidget extends StatefulWidget {
  const RouteingMapWidget({Key? key}) : super(key: key);

  @override
  State<RouteingMapWidget> createState() => _RouteingMapWidgetState();
}

class _RouteingMapWidgetState extends State<RouteingMapWidget> {
  List<Marker> markers = [];
  LatLng? currentLocation;
  late Completer<GoogleMapController> _controller;
  late CameraPosition initialCameraPosition;
  late GoogleMapController _googleMapController;
  Map<PolylineId, Polyline> polylines = {};
  late RouteingProvider provider;

  @override
  void initState() {
    provider = Provider.of<RouteingProvider>(context, listen: false);
    _controller = Completer();
    initialCameraPosition = const CameraPosition(
      target: LatLng(21.430399643909276, 40.47577334606505),
      zoom: 15.7,
    );
    _getCurrentLocation();
    super.initState();
  }

  Future<void> selectLocation(LatLng selectedLocation, String title) async {
    provider.endLocation = selectedLocation;
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(selectedLocation.toString()),
      position: selectedLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: title,
      ),
    ));
  }

  Future<void> getDirections() async {
    List<LatLng> polylineCoordinates = [];
    if (currentLocation == null || provider.endLocation == null) return;

    for (var point in await provider.getRouteBetweenCoordinates(
        currentLocation!, provider.endLocation!)) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
    addPolyLine(polylineCoordinates);
  }

  void addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Theme.of(context).primaryColor,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  _getCurrentLocation() async {
    Position position = await provider.determinePosition();
    currentLocation = LatLng(position.latitude, position.longitude);
    if (currentLocation == null) return;
    final cameraPosition = CameraPosition(
      target: currentLocation!,
      zoom: 15.0,
    );
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _handleTap(LatLng point) async {
    provider.endLocation = point;
    await _getCurrentLocation();
    await getDirections();
    markers.add(Marker(
      markerId: const MarkerId("1"),
      position: point,
    ));

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Selector<RouteingProvider, LatLng?>(
          selector: (p0, p1) => p1.endLocation,
          builder: (context, value, child) {
            if (value != null) {
              markers = [];
              markers.add(Marker(
                markerId: const MarkerId("1"),
                position: value,
                infoWindow: const InfoWindow(
                  title: 'hospital-location',
                ),
              ));
            }
            return GoogleMap(
              markers: Set<Marker>.of(markers),
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              gestureRecognizers: Set()
                ..add(
                    Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer()))
                ..add(
                    Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer())),
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
                _controller.complete(controller);
              },
              onTap: _handleTap,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.location_on),
      ),
    );
  }
}
