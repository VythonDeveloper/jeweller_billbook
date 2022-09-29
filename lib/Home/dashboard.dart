import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/mortgage.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardUi extends StatefulWidget {
  const DashboardUi({Key? key}) : super(key: key);

  @override
  State<DashboardUi> createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<dynamic> transactionsMap = [];

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  void userDetails() async {
    if (UserData.uid == '') {
      final SharedPreferences prefs = await _prefs;
      UserData.uid = prefs.getString('USERKEY')!;
      UserData.username = prefs.getString('USERNAMEKEY')!;
      UserData.userDisplayName = prefs.getString('USERDISPLAYNAMEKEY')!;
      UserData.email = prefs.getString('USEREMAILKEY')!;
      UserData.profileUrl = prefs.getString('USERPROFILEKEY')!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.storefront),
            SizedBox(
              width: 10,
            ),
            Text(UserData.userDisplayName),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            statusBlocks(),
            ItemTimeline(),
          ],
        ),
      ),
    );
  }

  Widget statusBlocks() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              StatsCard(
                onPress: () {},
                icon: Icons.file_download_outlined,
                cardColor: Color.fromARGB(255, 217, 241, 218),
                label: 'Mortage',
                amount: '₹ ' + '0',
              ),
              SizedBox(
                width: 10,
              ),
              StatsCard(
                onPress: () {},
                icon: Icons.file_upload_outlined,
                cardColor: Color.fromARGB(255, 255, 223, 227),
                label: 'Sales',
                amount: '₹ ' + '0',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              StatsCard(
                onPress: () {
                  PageRouteTransition.push(context, LowStockUI());
                },
                icon: null,
                cardColor: Colors.grey.shade200,
                label: 'Value of Items',
                amount: 'Low Stocks',
              ),
              SizedBox(
                width: 10,
              ),
              StatsCard(
                onPress: () {},
                icon: Icons.bar_chart,
                cardColor: Colors.grey.shade300,
                label: 'Weekly Sale',
                amount: '₹ ' + '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget StatsCard({final onPress, label, icon, amount, cardColor}) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(label),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        icon,
                        size: 18,
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ItemTimeline() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          FutureBuilder<dynamic>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('transactions')
                .orderBy('id', descending: true)
                .get(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15, left: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timeline,
                              size: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Timeline",
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return snapshot.data.docs[index]['type'] ==
                                  "StockTransaction"
                              ? transactionCard(
                                  txnMap: snapshot.data.docs[index])
                              : mortgageCard(txnMap: snapshot.data.docs[index]);
                        },
                      ),
                    ],
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(top: 40, left: 15),
                  child: Text(
                    "No\nTransactions",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade300,
                    ),
                  ),
                );
              }
              return LinearProgressIndicator();
            }),
          ),
        ],
      ),
    );
  }

  Widget transactionCard({required var txnMap}) {
    return Container(
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${txnMap['itemCategory']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${txnMap['itemName']}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Constants.dateFormat(txnMap['date']),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Change",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      txnMap['change'].toString().replaceAll('#', '\n'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Final",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${txnMap['finalStockWeight']} ${txnMap['unit']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${txnMap['finalStockPiece']} pcs",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget mortgageCard({required var txnMap}) {
  //   return Container(
  //     color: Colors.grey.shade100,
  //     margin: EdgeInsets.only(bottom: 10),
  //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Mortgage",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: primaryColor,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   Text(
  //                     "${txnMap['shopName']}",
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   Text(
  //                     Constants.dateFormat(txnMap['date']),
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.black,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 children: [
  //                   Text(
  //                     txnMap['status'],
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: txnMap['status'] == "Active"
  //                           ? Color.fromARGB(255, 76, 135, 175)
  //                           : Color.fromARGB(255, 247, 122, 20),
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   Text(
  //                     "Total Due",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: primaryColor,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   Text(
  //                     "₹ " + txnMap['amount'].toStringAsFixed(2),
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.black,
  //                       fontSize: 13,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Text(
  //                     "In Profit",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: txnMap['status'] == "Active"
  //                           ? Colors.green
  //                           : Colors.red,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   Text(
  //                     "Valuation",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: primaryColor,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   Text(
  //                     "20",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.black,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
