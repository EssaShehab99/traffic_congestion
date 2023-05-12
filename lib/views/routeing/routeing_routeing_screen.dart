import 'package:flutter/material.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

import '../road/road_map_widget.dart';

class RouteingScreen extends StatefulWidget {
  const RouteingScreen({Key? key}) : super(key: key);

  @override
  State<RouteingScreen> createState() => _RouteingScreenState();
}

class _RouteingScreenState extends State<RouteingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            RoadMapWidget(),
            Padding(
                padding: EdgeInsets.all(SharedValues.padding),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1),spreadRadius: 5,blurRadius: 5)
                    ]
                  ),
                  child: TextFieldWidget(
                    controller: TextEditingController(),
                    hintText: 'search destination',
                    fillColor: Theme.of(context).colorScheme.background,
                    suffixIcon:
                        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
