import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jeweller_stockbook/Signin/splashUI.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyBSYGVmRthIIUxsNLwAMlehjzuqZwAvyoM',
        appId: '1:544489735185:android:e88d7488e386e66990ddb0',
        messagingSenderId: '',
        projectId: 'jeweller-billbook'),
  );
  await Hive.initFlutter();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    systemColors();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockBook',
      theme: kTheme(),
      home: SplashUI(),
    );
  }
}
