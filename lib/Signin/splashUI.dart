import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/home.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/select_Contacts.dart';
import '../Helper/user.dart';
import '../constants.dart';

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
    await userDetails();
    await getContacts();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> getContacts() async {
    setState(() {});
    Constants.myContacts = await SelectContact().getContacts();
    // Constants.myContacts.addAll(contactsList);
    setState(() {});
  }

  Future<void> userDetails() async {
    if (UserData.uid == '') {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      UserData.uid = prefs.getString('USERKEY')!;
      UserData.username = prefs.getString('USERNAMEKEY')!;
      UserData.userDisplayName = prefs.getString('USERDISPLAYNAMEKEY')!;
      UserData.email = prefs.getString('USEREMAILKEY')!;
      UserData.profileUrl = prefs.getString('USERPROFILEKEY')!;
      setState(() {});
    }
  }

  // getMyTokenID() async {
  //   var status = await OneSignal.shared.getDeviceState();
  //   tokenId = status!.userId!;

  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Userdetails.uid)
  //       .update({'tokenId': tokenId});

  //   Userdetails.myTokenId = tokenId;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoading(),
            SizedBox(
              height: 10,
            ),
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
