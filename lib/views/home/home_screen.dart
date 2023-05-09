import 'package:flutter/material.dart';
import 'package:traffic_congestion/views/map_screen/map_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: MapWidget(),
    ));
  }
}
