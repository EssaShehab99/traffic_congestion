import 'package:flutter/material.dart';
import 'package:traffic_congestion/views/road/road_map_widget.dart';
import 'package:traffic_congestion/views/routing/routing_map_widget.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';

class RoadScreen extends StatefulWidget {
  const RoadScreen({Key? key}) : super(key: key);

  @override
  State<RoadScreen> createState() => _RoadScreenState();
}

class _RoadScreenState extends State<RoadScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.all(SharedValues.padding),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(SharedValues.borderRadius))
              ),
              child: Text(
                'select the road',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Expanded(child: const RoutingMapWidget()),
          ],
        ),
      ),
    );
  }
}
