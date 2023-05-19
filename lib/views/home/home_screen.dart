import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/routing_provider.dart';
import 'package:traffic_congestion/data/utils/utils.dart';
import 'package:traffic_congestion/views/paeking/parking_screen.dart';
import 'package:traffic_congestion/views/road/roading_screen.dart';
import 'package:traffic_congestion/views/routing/routing_screen.dart';
import 'package:traffic_congestion/views/shared/assets_variables.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:traffic_congestion/views/shared/loading_widget.dart';
import 'package:traffic_congestion/views/shared/shared_components.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          SharedComponents.appBar('Home'),
          Expanded(
              child: FutureBuilder(
                  future: Provider.of<RoutingProvider>(context, listen: false).determinePosition(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingWidget();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    return ListView(
                      children: [
                        _buildButtonWidget(
                          image: AssetsVariable.routing,
                          text: 'Routing',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RoutingScreen()));
                          },
                        ),
                        _buildButtonWidget(
                          image: AssetsVariable.parking,
                          text: 'Parking',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ParkingScreen()));
                          },
                        ),
                        // _buildButtonWidget(
                        //     image: AssetsVariable.road, text: 'Show Road Status',onPressed: () {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (context) => const RoadScreen()));
                        //
                        // },),
                      ],
                    );
                  }))
        ],
      ),
    ));
  }

  Widget _buildButtonWidget(
      {required String image, required String text, VoidCallback? onPressed}) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(SharedValues.padding),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SharedValues.borderRadius),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: ButtonWidget(
            onPressed: onPressed,
            elevation: 0,
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(SharedValues.padding),
              child: SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: SvgPicture.asset(
                            height: 100,
                            width: 100,
                            fit: BoxFit.scaleDown,
                            image),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(SharedValues.padding),
                          child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                text,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
