import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_billbook/Home/home.dart';
import 'package:jeweller_billbook/Signin/loginUI.dart';
import 'package:jeweller_billbook/services/auth.dart';
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
        systemNavigationBarColor: Color.fromARGB(255, 232, 235, 255),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    PageRouteTransition.effect = TransitionEffect.rightToLeft;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockBook',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue.shade900,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'San',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 232, 235, 255),
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentuser(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginUI();
          }
        }),
      ),
    );
  }
}
