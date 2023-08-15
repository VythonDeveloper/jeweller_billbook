import 'package:flutter/material.dart';

Color kPrimaryColor = Color(0xFFFAF0D7);
Color kLightPrimaryColor = Color(0xFFFFD9C0);
Color kAccentColor = Color.fromARGB(255, 188, 227, 250);
Color kCardCOlor = Color(0xFFCCEEBC);
Color kTileBorderColor = Color(0xFFA2ECF7);
Color kTileColor = Color(0xFFEFFDFF);

Color profitColor = Colors.green.shade700;
Color lossColor = Colors.red;
Color textColor = Colors.grey.shade700;

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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
      ),
    );
