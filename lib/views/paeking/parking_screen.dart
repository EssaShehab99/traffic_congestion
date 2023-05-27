import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/models/parking.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/providers/parking_provider.dart';
import 'package:traffic_congestion/data/utils/extension.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:traffic_congestion/views/shared/shared_components.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  late ParkingProvider provider;
  @override
  void initState() {
    provider = Provider.of<ParkingProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
        Container(
          height: 80,
          width: double.infinity,
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.all(SharedValues.padding),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(SharedValues.borderRadius))),
          child: Text(
            'Parking',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Expanded(
            child: FutureBuilder(
                future: Provider.of<ParkingProvider>(context, listen: false)
                    .getAllParking(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: [
                      Consumer<ParkingProvider>(builder: (context, value, child){
                            return Row(
                              children: [
                                _buildParkingColumn(value.groupParking.get(0) ?? []),
                                const SizedBox(width: SharedValues.padding * 2),
                                _buildParkingColumn(value.groupParking.get(1) ?? []),
                              ],
                            );
                          })
                    ],
                  );
                }))
      ]),
    ));
  }

  Expanded _buildParkingColumn(List<Parking> parking) {
    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderCard(parking.get(0)?.group??''),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parking.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 65,
            maxCrossAxisExtent: 100,
          ),
          itemBuilder: (context, index) => _buildParkingCard(parking[index]),
        )
      ],
    ));
  }

  Container _buildHeaderCard(String text) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.all(SharedValues.padding * 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).primaryColor),
      child: Center(
          child: Text(text, style: Theme.of(context).textTheme.headline3)),
    );
  }

  Container _buildParkingCard(Parking parking) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.all(SharedValues.padding * 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: parking.wasTaken ?? false
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).primaryColor),
      child: InkWell(
        onTap: () {
          SharedComponents.showBottomSheet(context,
              child: StatefulBuilder(builder: (context, setStateWidget) {
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(SharedValues.padding),
                  child: ButtonWidget(
                    onPressed: () async {
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
                      if (timeOfDay != null) {
                        final now = DateTime.now();
                        provider.from = DateTime(now.year, now.month, now.day,
                            timeOfDay.hour, timeOfDay.minute);
                      }
                      setStateWidget(() {});
                    },
                    child: Text(
                      provider.from != null
                          ? DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa')
                              .format(provider.from!)
                          : 'From',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: ButtonWidget(
                    onPressed: () async {
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
                      if (timeOfDay != null) {
                        final now = DateTime.now();
                        provider.to = DateTime(now.year, now.month, now.day,
                            timeOfDay.hour, timeOfDay.minute);
                      }
                      debugPrint(
                          '================provider.to: ${timeOfDay?.toString()}==================');
                      setStateWidget(() {});
                    },
                    child: Text(
                      provider.to != null
                          ? DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa')
                              .format(provider.to!)
                          : 'To',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SharedValues.padding),
                  child: ButtonWidget(
                    onPressed: () async {
                      Result result = await provider.reservedParking(parking);
                      if (!mounted) return;
                      if (result is Success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                              content: Text(
                            'Success!',
                            style: Theme.of(context).textTheme.button,
                          )),
                        );
                      } else if (result is NotValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.yellow,
                              content: Text('This position is previously reserved!',
                                  style: Theme.of(context).textTheme.subtitle1)),
                        );
                      } else if (result is Error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Failure!',
                                  style: Theme.of(context).textTheme.button)),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Reserved',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              ],
            );
          }));
        },
        child: Center(
            child: Text(parking.name,
                style: Theme.of(context).textTheme.headline3)),
      ),
    );
  }
}
