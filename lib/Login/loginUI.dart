import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import '../Home/dashboardUI.dart';
import '../utils/colors.dart';
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
        showSnackBar(context, 'Invalid PIN. Try again ...');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: sdp(context, 15),
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    Constants.shopName,
                    style: TextStyle(
                        fontSize: sdp(context, 20),
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  // Text(
                  //   'Enter PIN',
                  //   style: TextStyle(
                  //     fontSize: sdp(context, 20),
                  //     color: kPrimaryColor,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  FittedBox(
                    child: Center(
                      child: OtpTextField(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        numberOfFields: 5,
                        borderColor: Colors.grey.shade600,
                        focusedBorderColor: Colors.blue,
                        showFieldAsBox: true,
                        fieldWidth: sdp(context, 50),
                        obscureText: true,
                        autoFocus: true,
                        onSubmit: (value) {
                          pin = value;
                        },
                      ),
                    ),
                  ),
                  height50,
                  ElevatedButton(
                    onPressed: () {
                      if (!isLoading) {
                        logIn(pin);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      child: Text('Proceed'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: fullScreenLoading(context),
          ),
        ],
      ),
      // floatingActionButton: !isLoading
      //     ? ElevatedButton(
      //         onPressed: () {
      //           if (!isLoading) {
      //             logIn(pin);
      //           }
      //         },
      //         child: Text('Proceed'),
      //       )
      //     : SizedBox(),
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
