import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/views/shared/dropdown_field_widget.dart';
import '/views/shared/shared_components.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  late Completer<GoogleMapController> _controller;
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    _controller = Completer();
    initialCameraPosition = const CameraPosition(
      target: LatLng(21.430399643909276, 40.47577334606505),
      zoom: 16.7,
    );
    super.initState();
  }

  _handleTap(LatLng point) {
    setState(() {
      debugPrint("========MapScreen->point: ${point.toString()}==========");
      markers.add(Marker(
        markerId: const MarkerId("1"),
        position: point,
        infoWindow: const InfoWindow(
          title: 'hospital-location',
        ),
      ));
    });
  }
  Future<void> getDirections() async { }


  Future<void> selectLocation(LatLng selectedLocation, String title) async {
    markers = [
      Marker(
        markerId: MarkerId(selectedLocation.toString()),
        position: selectedLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: title,
        ),
      )
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop:   () async{
            return true;
          },
          child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        markers: Set<Marker>.of(markers),
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(
                  () => PanGestureRecognizer()))
          ..add(Factory<ScaleGestureRecognizer>(
                  () => ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(
                  () => TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: _handleTap,
      ),
    ),
        ));
  }
}

