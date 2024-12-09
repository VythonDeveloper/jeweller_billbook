import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:jeweller_stockbook/utils/kOTPField.dart';
import 'package:jeweller_stockbook/utils/kScaffold.dart';
import '../Home/RootUI.dart';
import '../utils/components.dart';

import 'package:hive/hive.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  String pin = '';

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  logIn(String pin) async {
    setState(() => isLoading = true);
    print(pin);
    String encrypted_password = encryptPassword(pin);

    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: UserData.uid)
        .where('password', isEqualTo: encrypted_password)
        .get()
        .then((value) async {
      if (value.docs.length > 0) {
        var data = value.docs[0].data();

        UserData.email = data['email'];
        UserData.userDisplayName = data['name'];
        UserData.username = data['username'];
        UserData.profileUrl = data['imgUrl'];
        UserData.goldRate = data['goldDetails']['rate'];

        var box = await Hive.openBox('userBox');

        await box.putAll({
          'uid': data['uid'],
          'password': pin,
        });

        setState(() => isLoading = false);
        navPushReplacement(context, DashboardUI());
      } else {
        setState(() => isLoading = false);
        kSnackbar(context, 'Invalid PIN. Try again ...');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      isLoading: isLoading,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Constants.shopName,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w700),
              ),
              kHeight(50),
              Text("Enter the security code"),
              height20,
              KOtpField(
                length: 5,
                onCompleted: (val) {
                  setState(() {
                    pin = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              if (!isLoading) {
                logIn(pin);
              }
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Text(
                'Proceed',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget CustomTextField(
  //     {final label,
  //     obsecureText,
  //     textCapitalization,
  //     controller,
  //     keyboardType,
  //     validator,
  //     icon}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 10),
  //     child: TextFormField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       textCapitalization: textCapitalization,
  //       obscureText: obsecureText,
  //       decoration: InputDecoration(
  //         contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //         prefixIcon: icon,
  //         labelText: label,
  //         border: UnderlineInputBorder(),
  //       ),
  //       validator: validator,
  //     ),
  //   );
  // }
}
