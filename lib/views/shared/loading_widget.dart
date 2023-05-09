import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/views/shared/shared_values.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )),
          const SizedBox(height: SharedValues.padding * 5),
          Text("${"loading-data".tr()}...", style: Theme.of(context).textTheme.button)
        ],
      ),
    );
  }
}
