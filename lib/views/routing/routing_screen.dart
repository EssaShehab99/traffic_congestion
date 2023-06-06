import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/routing_provider.dart';
import 'package:traffic_congestion/views/routing/routing_map_widget.dart';
import 'package:traffic_congestion/views/shared/assets_variables.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTime();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SlidingUpPanel(
          minHeight: 125,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(SharedValues.borderRadius)),
          body: Stack(
            children: [
              const RoutingMapWidget(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ButtonWidget(
                    isCircle: true,
                    color: Theme.of(context).colorScheme.background,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Selector<RoutingProvider, String?>(
                              selector: (p0, p1) => p1.arriveAt,
                              builder: (context, value, child) => Text(
                                  value ?? 'must-arrive-at'.tr(),
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () => provider.setArriveTime(
                                provider.timeToArriveAt, context),
                            icon: Icon(
                              Icons.refresh_outlined,
                              color: Theme.of(context).primaryColor,
                            )),
                      ],
                    ),
                    onPressed: () async {
                     await showTime();
                    },
                  ),
                ),
              ),
            ],
          ),
          panel: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return Consumer<RoutingProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: SharedValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 15,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: SharedValues.padding),
                  height: 3,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SharedValues.borderRadius),
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.2)),
                ),
              ),
            ),
            if (provider.routes.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text:
                          "${((provider.routes.firstWhere((element) => element.isSelected).travelTime) / 60).truncate()} min",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          ' (${provider.routes.firstWhere((element) => element.isSelected).distance})',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(fontSize: 20)),
                    ])),
                  ),
                  Expanded(child: Selector<RoutingProvider, int>(
                    selector: (context, provider) => provider.countUsersCrossing,
                    builder: (context, value, child) {
                      return Text(
                        '${'number-route'.tr()} $value',
                        style: Theme.of(context).textTheme.headline4,
                      );
                    },
                  )
                  )
                ],
              )
            else ...[
              const SizedBox(height: SharedValues.padding * 2),
              Align(
                alignment: Alignment.topCenter,
                child: ButtonWidget(
                  onPressed: () async {
                    await provider.getRoutes();
                  },
                  isCircle: true,
                  child: Padding(
                    padding: const EdgeInsets.all(SharedValues.padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_searching_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(width: SharedValues.padding),
                        Text("show-location".tr(),
                            style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                ),
              )
            ],
            const SizedBox(height: SharedValues.padding),
            Text(
              'Fastest route now due to traffic conditions',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: SharedValues.padding),
            if (!provider.isConfirmLocation && provider.routes.isNotEmpty)
              Text("Confirm the track by clicking on it",
                  style: Theme.of(context).textTheme.headline5),
            if (provider.isConfirmLocation &&
                provider.routes.isNotEmpty &&
                provider.arriveAt == null)
              Text("Enter the time you want to arrive",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Theme.of(context).colorScheme.error)),
            if (provider.isConfirmLocation &&
                provider.routes.isNotEmpty &&
                provider.arriveAt != null)
              Text(provider.arriveAt!,
                  style: Theme.of(context).textTheme.headline5),
            if(provider.countAvailableParking!=0)
              Text("${"available-parking".tr()}${provider.countAvailableParking}",
                  style: Theme.of(context).textTheme.headline5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(SharedValues.borderRadius),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView.builder(
                  itemCount:
                      value.routes.length, // Replace with the actual item count
                  itemBuilder: (context, index) {
                    final route = value.routes[index];
                    return InkWell(
                      onTap: () {
                        provider.selectRoute(route);
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.all(SharedValues.padding),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SharedValues.borderRadius),
                            color: route.isSelected
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onError),
                        child: Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.all(SharedValues.padding),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color:
                                          route.color ?? Colors.transparent)),
                              child: SvgPicture.asset(AssetsVariable.track,
                                  color: route.color ?? Colors.transparent,
                                  width: 25,
                                  height: 25),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: SharedValues.padding * 0.5,
                                        horizontal: SharedValues.padding * 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            SharedValues.borderRadius * 2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                    child: Text(
                                        "${(route.travelTime / 60).truncate()} min",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4)),
                              ],
                            ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showTime() async {

    TimeOfDay? timeOfDay = await showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.light().copyWith(
          dialogBackgroundColor: Colors
              .white, // Set the background color of the dialog
          primaryColor:
          Colors.blue, // Set the primary color of the app
          hintColor: Colors
              .orange, // Set the accent color of the app
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 16, // Set the font size for headlines
              fontWeight: FontWeight
                  .bold, // Set the font weight for headlines
              color:
              Colors.black, // Set the color for headlines
            ),
            bodyMedium: TextStyle(
              fontSize: 14, // Set the font size for body text
              color:
              Colors.grey, // Set the color for body text
            ),
          ),
        ),
        child: TimePickerDialog(
          initialTime: TimeOfDay.now(),
        ),
      ),
    );

    if(!mounted)return;
    if (timeOfDay != null) {
      await provider.setArriveTime(timeOfDay, context);
    }

  }
}
