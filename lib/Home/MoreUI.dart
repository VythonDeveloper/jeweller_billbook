import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/Login/loginUI.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:jeweller_stockbook/utils/kScaffold.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGoldRate();
  }

  void fetchGoldRate() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _goldRate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      isLoading: isLoading,
      appBar: AppBar(
        title: Text('More'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("For Mortgage Purpose"),
                height10,
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kColor(context).secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Gold Rate',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sdp(context, 15),
                          color: kColor(context).secondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      height10,
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _goldRate,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(.5),
                            hintText: '0',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            suffixText: "/GMS",
                            prefixText: "₹ ",
                            border: UnderlineInputBorder(),
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
                            if (_formKey.currentState!.validate() &&
                                !isLoading) {
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

                                kSnackbar(context, "Gold Rate updated!");
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
                height50,
                ElevatedButton(
                  onPressed: () async {
                    if (!isLoading) {
                      await Hive.deleteBoxFromDisk('userBox');
                      navPopUntilPush(context, LoginUI());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColor(context).error,
                    foregroundColor: kColor(context).onError,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.power_settings_new),
                      width10,
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: kColor(context).onError,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? fullScreenLoading(context, loadingText: 'Updating Rate ...')
              : SizedBox(),
        ],
      ),
    );
  }
}
