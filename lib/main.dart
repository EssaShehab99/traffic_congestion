
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/di/service_locator.dart';
import 'package:traffic_congestion/data/local/sharedpref_helper/preference_variable.dart';
import 'package:traffic_congestion/data/local/sharedpref_helper/preferences.dart';
import 'package:traffic_congestion/data/models/user.dart';
import 'package:traffic_congestion/data/providers/auth_provider.dart';
import 'package:traffic_congestion/style/theme_app.dart';
import 'package:traffic_congestion/firebase_options.dart';
import 'package:traffic_congestion/views/auth/login_screen.dart';
import 'package:traffic_congestion/views/auth/onboarding_screen.dart';
import 'package:traffic_congestion/views/auth/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final preferences = Preferences.instance;
  String? date = (await preferences.get(PreferenceVariable.user))?.toString();
  User? user = date == null ? null : User.fromJson(jsonDecode(date));

  setup();
  runApp(EasyLocalization(
    fallbackLocale: const Locale('ar', 'SA'),
    startLocale: const Locale('en', 'US'),
    saveLocale: true,
    supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
    path: 'assets/translations',
    child: MyApp(user: user),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..setUser(user)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeApp.light,
        home: const Register(),
        // home: user == null ? const SignInScreen() : const HomeScreen(),
        // home:  const SignInScreen(),
        // home: const MainScreen(),
        // home: VerifyOTP(isSignUp: true),
      ),
    );
  }
}
