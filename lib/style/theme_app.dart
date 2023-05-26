import 'package:flutter/material.dart';
import '/views/shared/shared_values.dart';

class ThemeApp {
  ThemeApp._privateConstructor();

  static final ThemeApp _instance = ThemeApp._privateConstructor();

  static ThemeApp get instance => _instance;

  static ThemeData get light {

    return ThemeData(
      fontFamily: "Cairo",
      primaryColor: const Color(0xFF2F8F61),
      useMaterial3: true,
      hintColor: const Color(0xFFEAEAEA),
      backgroundColor: const Color(0xFFFDFAED),
      scaffoldBackgroundColor: const Color(0xFFFDFAED),
      iconTheme: const IconThemeData(color: Color(0xFFFDFAED), size: 25),
      dividerColor: const Color(0xFF939393),
      indicatorColor: const Color(0xFFEAEAEA),
      cardColor: const Color(0xFFFDFAED),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2F8F61)),
      appBarTheme: const AppBarTheme(color: Color(0xFFFAFAFA)),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SharedValues.borderRadius*5),
            borderSide: const BorderSide(color: Colors.transparent,)
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SharedValues.borderRadius*5),
            borderSide: const BorderSide(color: Colors.transparent,)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SharedValues.borderRadius*5),
            borderSide: const BorderSide(color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SharedValues.borderRadius*5),
            borderSide: const BorderSide(color: Colors.transparent)),
        errorStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFFFF6464)),
        fillColor: const Color(0xFFE5E5E5),
        filled: true,
        contentPadding: const EdgeInsets.all(SharedValues.padding*2),
        constraints: BoxConstraints(minHeight: 55),
        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF939393)),
      ),
      colorScheme:  const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFFABC80),
          onPrimary: Color(0xFFFDFAED),
          secondary: Color(0xFF91EFC1),
          onSecondary: Color(0xFFFDFAED),
          error: Color(0xFFE86173),
          onError: Color(0xFFFDFAED),
          background: Color(0xFFFFFFFF),
          onBackground: Color(0xFF000000),
          surface: Color(0xFF82CBA9),
          onSurface: Color(0xFFDBEAFF)),
      textTheme: const TextTheme(
          headline1: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color(0xFFFDFAED)),
          headline2: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF2F8F61)),
          headline3: TextStyle(
              fontSize: 16,
              color: Color(0xFFFDFAED)),
          headline4: TextStyle(fontSize: 14, color: Color(0xFF000000)),
          headline5: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 14, color: Color(0xFF2F8F61)),
          bodyText1: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF000000)),
          headlineLarge: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF2F8F61)),
          bodyText2: TextStyle(fontSize: 14, color: Color(0xFF939393)),
          subtitle1: TextStyle(fontSize: 12, color: Color(0xFF2F8F61)),
          subtitle2: TextStyle(fontSize: 12, color: Color(0xFF2F8F61)),
          button: TextStyle(fontSize: 14, color: Color(0xFFFDFAED)),
          labelMedium: TextStyle(fontSize: 13, color: Color(0xFF939393))));
  }
}
