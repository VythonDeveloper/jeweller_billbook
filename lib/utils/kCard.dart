import 'package:flutter/material.dart';

import 'components.dart';

class KCard extends StatelessWidget {
  final void Function()? onTap;
  final Widget? child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double borderWidth;
  final Color color;
  final Color? borderColor;
  const KCard({
    super.key,
    this.onTap,
    this.radius = 15,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color = const Color(0xFFEEEEEE),
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: kRadius(radius),
            color: color,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null),
        child: child,
      ),
    );
  }
}
