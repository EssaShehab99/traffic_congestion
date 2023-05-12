import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traffic_congestion/views/shared/assets_variables.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';

class SharedComponents {
  SharedComponents._privateConstructor();
  static final SharedComponents _instance =
      SharedComponents._privateConstructor();
  static SharedComponents get instance => _instance;

  static showSnackBar(BuildContext context, String text,
      {Color? backgroundColor}) {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ));
    });
  }

  static Widget indicator(int length, int selected) {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) {
          if (index == selected) {
            return Container(
              width: 40,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor),
            );
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              child: CircleAvatar(
                radius: 5,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }).toList(),
      );
    });
  }

  static Widget appBar(String title,
      {bool? withBackBtn, bool? withUserOptions}) {
    List<String> listItem = ["Sign out"];
    return Builder(
        builder: (context) => Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(SharedValues.borderRadius)),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      SharedValues.padding * 2,
                      0,
                      SharedValues.padding * 2,
                      SharedValues.padding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.headline2?.copyWith(fontSize: 25),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: SvgPicture.asset(
                            AssetsVariable.logo,
                            alignment: AlignmentDirectional.centerEnd,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  static Future<dynamic> showBottomSheet(BuildContext context,
      {double? height, Widget? child}) {
    final mediaQuery = MediaQuery.of(context);
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(SharedValues.borderRadius * 2))),
      useRootNavigator: true,
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          margin: EdgeInsets.only(top: mediaQuery.padding.top),
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          height: (mediaQuery.orientation == Orientation.portrait)
              ? height ?? (mediaQuery.size.height * 0.75)
              : mediaQuery.size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(SharedValues.borderRadius)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: SharedValues.padding * 2),
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius:
                      BorderRadius.circular(SharedValues.borderRadius)),
                ),
              ),
              Expanded(child: child ?? const SizedBox.shrink())
            ],
          ),
        ),
      ),
    );
  }
}
