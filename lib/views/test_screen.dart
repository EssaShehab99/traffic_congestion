import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/models/parking.dart';
import 'package:traffic_congestion/data/providers/parking_provider.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ButtonWidget(
          onPressed: () async {
            final provider=Provider.of<ParkingProvider>(context,listen: false);
            for (var i = 1; i < 21; ++i) {
            await  provider.insertParking(Parking(name: 'A $i',group: 'A',order: i));
            }
            for (var i = 1; i < 21; ++i) {
              await  provider.insertParking(Parking(name: 'B $i',group: 'B',order: i));
            }

          },
          child: Text(
            'Add Data',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }
}
