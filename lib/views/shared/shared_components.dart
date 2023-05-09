import 'package:flutter/material.dart';

class SharedComponents {
  SharedComponents._privateConstructor();
  static final SharedComponents _instance =
      SharedComponents._privateConstructor();
  static SharedComponents get instance => _instance;


  static showSnackBar(BuildContext context, String text, {Color? backgroundColor}) {
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

  // static Future<dynamic> showOverlayLoading(
  //         BuildContext context, Future<Object>? futureFun,
  //         {Color? color, Color? progressColor}) =>
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       barrierColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: () async => false,
  //           child: FutureBuilder(
  //               future: futureFun(),
  //               builder: (_, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.done) {
  //                   WidgetsBinding.instance.addPostFrameCallback((_) {
  //                     Navigator.pop(context, snapshot.data);
  //                   });
  //                 }
  //                 return SizedBox(
  //                     height: 200,
  //                     width: 200,
  //                     child: Align(
  //                       child: AvatarGlow(
  //                         glowColor: color ?? Theme.of(context).primaryColor,
  //                         duration: const Duration(
  //                           milliseconds: 2000,
  //                         ),
  //                         repeat: true,
  //                         showTwoGlows: true,
  //                         endRadius: 50,
  //                         child: Container(
  //                             height: 50,
  //                             width: 50,
  //                             decoration: BoxDecoration(
  //                                 color: Colors.white12,
  //                                 borderRadius: BorderRadius.circular(120)),
  //                             child: CircularProgressIndicator(
  //                               backgroundColor: progressColor ??
  //                                   Theme.of(context).colorScheme.primary,
  //                               valueColor: AlwaysStoppedAnimation<Color>(
  //                                   color ?? Theme.of(context).primaryColor),
  //                             )),
  //                       ),
  //                     ));
  //               }),
  //         );
  //       },
  //     );
}
