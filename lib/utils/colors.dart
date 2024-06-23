import 'package:flutter/material.dart';

Color kPrimaryColor = Color(0xFFFAF0D7);
Color kLightPrimaryColor = Color(0xFFFFD9C0);
Color kAccentColor = Color.fromARGB(255, 188, 227, 250);
Color kCardCOlor = Color(0xFFCCEEBC);
Color kTileBorderColor = Color(0xFFD7ECFE);
Color kTileColor = Color(0xFFEFFDFF);
Color profitColor = Colors.green.shade700;
Color lossColor = Colors.red;
Color textColor = Colors.grey.shade700;

ColorScheme kColor(context) => Theme.of(context).colorScheme;

ThemeData kThemeData() => ThemeData(
      fontFamily: 'Product',
      colorSchemeSeed: kPrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kLightPrimaryColor,
      ),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Product',
              letterSpacing: .5),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
      ),
    );
