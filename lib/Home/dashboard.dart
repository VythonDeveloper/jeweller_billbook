import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Mortage/mortage_billingUI.dart';
import 'package:jeweller_stockbook/Services/user.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/components.dart';
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
    final SharedPreferences prefs = await _prefs;
    UserData.uid = prefs.getString('USERKEY')!;
    UserData.username = prefs.getString('USERNAMEKEY')!;
    UserData.userDisplayName = prefs.getString('USERDISPLAYNAMEKEY')!;
    UserData.email = prefs.getString('USEREMAILKEY')!;
    UserData.profileUrl = prefs.getString('USERPROFILEKEY')!;
    setState(() {});
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFABButton(
        onPressed: () {
          PageRouteTransition.push(context, CreateMortgageUi())
              .then((value) => setState(() {}));
        },
        icon: Icons.receipt,
        label: 'Mortage Billing',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Timeline",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return transactionCard(txnMap: snapshot.data.docs[index]);
                    },
                  );
                }
                return Center(
                  child: Text(
                    "No Transactions",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                );
              }
              return LinearProgressIndicator();
            }),
          )
        ],
      ),
    );
  }

  Widget transactionCard({required var txnMap}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(txnMap['id'].toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice #",
                    ),
                    Text(
                      '29 sep 2022',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "₹ ",
                    ),
                    Text(
                      "Due ₹ ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
