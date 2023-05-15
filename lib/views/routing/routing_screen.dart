import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/routing_provider.dart';
import 'package:traffic_congestion/views/routing/routing_map_widget.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:traffic_congestion/views/shared/dropdown_field_widget.dart';
import 'package:traffic_congestion/views/shared/shared_components.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

import 'package:http/http.dart' as http;

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({Key? key}) : super(key: key);

  @override
  State<RoutingScreen> createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  late RoutingProvider provider;
  String? title;
  @override
  void initState() {
    provider = Provider.of<RoutingProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const RoutingMapWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed:() async => Provider.of<RoutingProvider>(context,listen: false).getRoutes(),
          child: Icon(Icons.location_on),
        ),
      ),
    );
  }
}
