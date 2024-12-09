import 'package:flutter/material.dart';

import 'package:jeweller_stockbook/utils/colors.dart';

import 'kCard.dart';

class Pill {
  Widget? child;
  String label;
  Color backgroundColor;
  Color textColor;
  EdgeInsetsGeometry padding;
  double? fontSize;

  Pill({
    this.child,
    this.fontSize,
    this.label = "text",
    this.backgroundColor = kPrimaryColor,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  });

  Widget get regular => KCard(
        child: child,
      );

  Widget get text => KCard(
        radius: 100,
        padding: padding,
        color: backgroundColor,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
