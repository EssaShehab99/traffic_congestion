import 'package:flutter/material.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
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
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Expanded(
            child: ListView(
          children: [
            Row(
              children: [
            Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      width: 70,
                      margin: EdgeInsets.all(SharedValues.padding*0.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:Theme.of(context).primaryColor
                      ),
                      child: Center(child: Text('A',style: Theme.of(context).textTheme.headline3)),
                    ),
                    Row(
              children: [
                    Expanded(
                        child: Column(
                      children: [
                      for (var i = 0; i < 10; ++i)
                        Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.all(SharedValues.padding*0.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                              color:i==0||i==5||i==9?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.onBackground
                          ),
                          child: Center(child: Text(i.toString(),style: Theme.of(context).textTheme.headline3)),
                        )],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                      for (var i = 10; i < 20; ++i)
                        Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.all(SharedValues.padding*0.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:Theme.of(context).colorScheme.onBackground
                          ),
                          child: Center(child: Text(i.toString(),style: Theme.of(context).textTheme.headline3)),
                        )],
                    )),
              ],
            ),
                  ],
                )),
            SizedBox(width: SharedValues.padding*5),
                Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          width: 70,
                          margin: EdgeInsets.all(SharedValues.padding*0.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:Theme.of(context).primaryColor
                          ),
                          child: Center(child: Text('B',style: Theme.of(context).textTheme.headline3)),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    for (var i = 0; i < 10; ++i)
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: EdgeInsets.all(SharedValues.padding*0.5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color:i==0||i==5||i==9?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.onBackground
                                        ),
                                        child: Center(child: Text(i.toString(),style: Theme.of(context).textTheme.headline3)),
                                      )],
                                )),
                            Expanded(
                                child: Column(
                                  children: [
                                    for (var i = 10; i < 20; ++i)
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: EdgeInsets.all(SharedValues.padding*0.5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color:i==11||i==14||i==17?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.onBackground
                                        ),
                                        child: Center(child: Text(i.toString(),style: Theme.of(context).textTheme.headline3)),
                                      )],
                                )),
                          ],
                        ),
                      ],
                    )),
              ],
            )
          ],
        ))
      ]),
    ));
  }
}
