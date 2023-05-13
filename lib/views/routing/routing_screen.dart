import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/routing_provider.dart';
import 'package:traffic_congestion/views/routing/routing_map_widget.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:traffic_congestion/views/shared/dropdown_field_widget.dart';
import 'package:traffic_congestion/views/shared/shared_components.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

import '../road/road_map_widget.dart';

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
        body: Stack(
          children: [
            const RoutingMapWidget(),
            Padding(
                padding: EdgeInsets.all(SharedValues.padding),
                child: StatefulBuilder(builder: (context, setStateWidget) {
                  return ButtonWidget(
                    isCircle: true,
                    onPressed: () {
                      SharedComponents.showBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(SharedValues.padding),
                          child: Column(
                            children: [
                              TextFieldWidget(
                                hintText: 'Search ...',
                                onChanged: provider.filterItems,
                              ),
                              Expanded(
                                child: Selector<RoutingProvider, List<String>>(
                                    selector: (p0, p1) => p1.filteredList,
                                    builder: (context, value, child) {
                                      return ListView.builder(
                                        itemCount: value.length,
                                        itemBuilder: (context, index) {
                                          final item = value[index];
                                          return ListTile(
                                            title: Text(item),
                                            onTap: () {
                                              setStateWidget(() {
                                                title=item;
                                                Navigator.pop(context);
                                              });
                                            },
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    height: 55,
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SharedValues.padding),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            title ?? 'Search ...',
                            style: Theme.of(context).textTheme.headlineLarge,
                          )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                              ))
                        ],
                      ),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }
}