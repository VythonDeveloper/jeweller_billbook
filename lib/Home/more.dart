import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/Helper/auth.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../Helper/user.dart';

class MoreUI extends StatefulWidget {
  const MoreUI({super.key});

  @override
  State<MoreUI> createState() => _MoreUIState();
}

class _MoreUIState extends State<MoreUI> {
  final _formKey = GlobalKey<FormState>();
  final _goldRate = new TextEditingController();
  int _updatedOn = 0;

  @override
  void initState() {
    super.initState();
    fetchGoldRate();
  }

  void fetchGoldRate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _goldRate.text = value.data()!['goldDetails']['rate'].toString();
        UserData.goldRate = int.parse(_goldRate.text);
        _updatedOn = value.data()!['goldDetails']['updatedOn'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _goldRate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text("For Mortgage Purpose"),
          SizedBox(
            height: 7,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryAlternateAccentColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryAlternateColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Current Gold Rate',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _goldRate,
                            decoration: InputDecoration(
                              hintText: '0',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              suffixText: "/GMS",
                              prefixText: "₹ ",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This is required";
                              }
                              if (int.parse(value) <= 0) {
                                return "Keep Positive";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 17,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Constants.timeAgo(_updatedOn),
                    ),
                  ],
                ),
                Divider(),
                Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        showLoading(context);
                        int goldRateValue = _goldRate.text.isEmpty
                            ? 0
                            : int.parse(_goldRate.text);

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserData.uid)
                            .update({
                          'goldDetails': {
                            'rate': int.parse(_goldRate.text),
                            'updatedOn': DateTime.now().millisecondsSinceEpoch,
                          },
                        }).then((value) async {
                          UserData.goldRate = goldRateValue;
                          _updatedOn = DateTime.now().millisecondsSinceEpoch;
                          setState(() {});
                          PageRouteTransition.pop(context);
                          showSnackBar(context, "Gold Rate updated!");
                        });
                      }
                    },
                    color: primaryAlternateColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: Colors.white,
                          size: 17,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          MaterialButton(
            onPressed: () {
              AuthMethods().signOut(context);
            },
            color: Color.fromARGB(255, 255, 239, 241),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: Colors.red,
              ),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.power_settings_new),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
