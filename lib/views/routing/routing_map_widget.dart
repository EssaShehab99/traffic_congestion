import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/routing_provider.dart';
import 'package:traffic_congestion/views/shared/loading_widget.dart';

class RoutingMapWidget extends StatefulWidget {
  const RoutingMapWidget({Key? key}) : super(key: key);

  @override
  State<RoutingMapWidget> createState() => _RoutingMapWidgetState();
}

class _RoutingMapWidgetState extends State<RoutingMapWidget> {
  List<Marker> markers = [];
  late Completer<GoogleMapController> _controller;
  late CameraPosition initialCameraPosition;
  late GoogleMapController _googleMapController;
  late RoutingProvider provider;

  @override
  void initState() {
    provider = Provider.of<RoutingProvider>(context, listen: false);
    _controller = Completer();
    initialCameraPosition =  CameraPosition(
      target: provider.destination,
      zoom: 12.5,
    );
    markers.add(Marker(
      markerId: MarkerId(provider.destination.hashCode.toString()),
      position: provider.destination, //position of marker
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<RoutingProvider, LatLng?>(
        selector: (p0, p1) => p1.destination,
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
          return FutureBuilder(
            future: provider.determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                return Selector<RoutingProvider,Map<PolylineId, Polyline>>(
                    selector: (p0, p1) => p1.polylines,
                    builder:(context, value, child) {
                      return GoogleMap(
                        markers: Set<Marker>.of(markers),
                        polylines: Set<Polyline>.of(value.values),
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
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
                          _googleMapController = controller;
                          _controller.complete(controller);
                        },
                      );
                    }
                );
              });
        });
  }
}
