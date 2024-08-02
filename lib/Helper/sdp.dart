
import 'package:flutter/material.dart';

double sdp(BuildContext context, double dp) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  // Consider both width and height for better responsiveness
  double screenSize = width > height ? width : height;

  // Adjust the scaling factor based on your preferences
  double scaleFactor = context.responsive(
    0.45,
    lg: 0.4,
    md: 0.45, // Adjust this for medium sized phone like poco x3 pro
    sm: 0.55, // Adjust this for redmi 3s prime phones
  );

  return (dp / 300) * screenSize * scaleFactor;
}

extension Responsive on BuildContext {
  T responsive<T>(
    T defaultValue, {
    T? sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    final w = MediaQuery.of(this).size.width;
    return w >= 1288
        ? (xl ?? lg ?? md ?? xl ?? defaultValue)
        : w >= 1024
            ? (lg ?? md ?? sm ?? defaultValue)
            : w >= 400
                ? (md ?? sm ?? defaultValue)
                : w >= 360
                    ? (sm ?? defaultValue)
                    : defaultValue;
  }
}
