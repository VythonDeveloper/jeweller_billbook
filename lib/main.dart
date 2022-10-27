import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/Signin/splashUI.dart';
import 'package:jeweller_stockbook/Signin/welcomeUI.dart';
import 'package:jeweller_stockbook/Helper/auth.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:page_route_transition/page_route_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryAccentColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    PageRouteTransition.effect = TransitionEffect.rightToLeft;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockBook',
      theme: ThemeData(
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        // fontFamily: 'San',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryAccentColor,
        ),
        useMaterial3: true,
      ),
      home: AuthMethods().getCurrentuser() != null ? SplashUI() : LoginUI(),

      // FutureBuilder(
      //   future: AuthMethods().getCurrentuser(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return SplashUI();
      //     } else {
      //       return LoginUI();
      //     }
      //   },
      // ),
    );
  }
}
