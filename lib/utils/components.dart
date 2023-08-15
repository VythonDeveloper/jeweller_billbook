import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/utils/colors.dart';

SizedBox get height5 => SizedBox(height: 5);
SizedBox get height10 => SizedBox(height: 10);
SizedBox get height15 => SizedBox(height: 15);
SizedBox get height20 => SizedBox(height: 20);
SizedBox get height50 => SizedBox(height: 50);

SizedBox get width5 => SizedBox(width: 5);
SizedBox get width10 => SizedBox(width: 10);
SizedBox get width15 => SizedBox(width: 15);
SizedBox get width20 => SizedBox(width: 20);

defaultSystemColors() => {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]),
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: kCardCOlor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
    };

Future<void> navPush(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<void> navPushReplacement(BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<void> navPopUntilPush(BuildContext context, Widget screen) {
  Navigator.popUntil(context, (route) => false);
  return navPush(context, screen);
}

Widget seeMoreButton(BuildContext context, {void Function()? onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(100),
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'See More',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: sdp(context, 10),
          color: Colors.black,
        ),
      ),
    ),
  );
}

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
        color: kLightPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: kPrimaryColor,
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

Container fullScreenLoading(BuildContext context,
    {String? loadingText = 'Loading...'}) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
    color: Colors.white.withOpacity(0.7),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.8,
          child: CircularProgressIndicator(),
        ),
        loadingText != null
            ? Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(loadingText),
              )
            : SizedBox(),
      ],
    ),
  );
}
