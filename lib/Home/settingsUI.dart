import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jeweller_stockbook/Login/loginUI.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';

import '../Helper/user.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});

  @override
  State<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  final _formKey = GlobalKey<FormState>();
  final _goldRate = new TextEditingController();
  int _updatedOn = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGoldRate();
  }

  void fetchGoldRate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
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
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              Text("For Mortgage Purpose"),
              SizedBox(
                height: 7,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.orangeAccent,
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && !isLoading) {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              isLoading = true;
                            });
                            int goldRateValue = _goldRate.text.isEmpty
                                ? 0
                                : int.parse(_goldRate.text);

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(UserData.uid)
                                .update({
                              'goldDetails': {
                                'rate': int.parse(_goldRate.text),
                                'updatedOn':
                                    DateTime.now().millisecondsSinceEpoch,
                              },
                            }).then((value) async {
                              UserData.goldRate = goldRateValue;
                              _updatedOn =
                                  DateTime.now().millisecondsSinceEpoch;

                              setState(() {
                                isLoading = false;
                              });

                              showSnackBar(context, "Gold Rate updated!");
                            });
                          }
                        },
                        color: Color(0xFF845104),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                onPressed: () async {
                  if (!isLoading) {
                    await Hive.deleteBoxFromDisk('userBox');
                    navPopUntilPush(context, LoginUI());
                  }
                },
                color: Colors.red.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),
                    width10,
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isLoading
              ? fullScreenLoading(context, loadingText: 'Updating Rate ...')
              : SizedBox(),
        ],
      ),
    );
  }
}
