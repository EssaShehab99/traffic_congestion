import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/providers/auth_provider.dart';
import 'package:traffic_congestion/views/auth/login_screen.dart';
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
    return Builder(
        builder: (context) => Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(SharedValues.borderRadius)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 1.5,
                        blurRadius: 5)
                  ]),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(SharedValues.padding * 2,
                      0, SharedValues.padding * 2, SharedValues.padding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: PopupMenuButton<String>(
                              onSelected: (value) {
                                print(context.locale.toString());

                                if(value=='ar'){
                                  context.setLocale(Locale('ar', 'SA'));
                                }else if(value=='en'){
                                  context.setLocale(Locale('en', 'US'));
                                }
                                else{
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logout();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    for (var item in ['Logout',context.locale.toString()=='en_US'?"ar":'en'])
                                      PopupMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                      )
                                  ],
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsVariable.user,
                                    alignment: AlignmentDirectional.centerEnd,
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: SharedValues.padding),
                                  Text(
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .user!
                                        .name,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  )
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Image.asset(
                            AssetsVariable.logo,
                            alignment: AlignmentDirectional.centerEnd,
                            width: 100,
                            height: 100,
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
