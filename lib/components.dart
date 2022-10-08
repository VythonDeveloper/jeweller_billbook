import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/colors.dart';

showLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(child: alert, onWillPop: () async => false);
    },
  );
}

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: TextStyle(
        color: primaryAccentColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: primaryColor,
  ));
}

Widget CustomFABButton({final onPressed, heroTag, icon, label}) {
  return FloatingActionButton.extended(
    onPressed: onPressed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    heroTag: heroTag,
    icon: Icon(icon),
    label: Text(label),
  );
}

Widget CustomLoading({final indicatorColor}) {
  return Transform.scale(
    scale: 0.7,
    child: Center(
      child: CircularProgressIndicator(
        color: indicatorColor,
      ),
    ),
  );
}

Center PlaceholderText({final text1, text2}) {
  return Center(
    child: Column(
      children: [
        Text(
          text1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
          ),
        ),
        Text(
          text2,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    ),
  );
}
