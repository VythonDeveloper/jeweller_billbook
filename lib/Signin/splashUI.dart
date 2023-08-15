import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Home/dashboardUI.dart';
import 'package:jeweller_stockbook/Login/loginUI.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';

import '../Helper/select_Contacts.dart';
import '../utils/constants.dart';

class SplashUI extends StatefulWidget {
  const SplashUI({Key? key}) : super(key: key);

  @override
  State<SplashUI> createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> with WidgetsBindingObserver {
  String tokenId = '';

  @override
  void initState() {
    super.initState();
    fetchPreData();
  }

  fetchPreData() async {
    await getContacts();
    await authUserDetails();
  }

  Future<void> getContacts() async {
    Constants.myContacts = await SelectContact().getContacts();
    setState(() {});
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> authUserDetails() async {
    var userBox = await Hive.openBox('userBox');

    if (userBox.get('uid') != null && userBox.get('password') != null) {
      String encrypted_password = encryptPassword(userBox.get('password'));
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

          navPushReplacement(context, DashboardUI());
        } else {
          navPushReplacement(context, LoginUI());
        }
      });
    } else {
      navPushReplacement(context, LoginUI());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoading(),
            height10,
            Text(
              'Fetching Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
