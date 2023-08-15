import 'package:flutter/material.dart';

//  OLD Colors
// Color primaryColor = Colors.indigo;
// Color primaryAccentColor = Color.fromARGB(255, 226, 230, 250);

//  NEW Colors
Color primaryColor = Color(0xFF3A4E5F);
Color primaryAccentColor = Color(0xFFE6F4FF);

Color profitColor = Colors.green.shade700;
Color lossColor = Colors.red;
Color textColor = Colors.grey.shade700;

ThemeData kThemeData() => ThemeData(
      fontFamily: 'Product',
      colorSchemeSeed: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryAccentColor,
      ),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
