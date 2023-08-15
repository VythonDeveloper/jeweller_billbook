import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Items/itemDetails.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  List<dynamic> transactionsMap = [];
  String timelineDateTitle = '';
  bool showDateWidget = false;

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
            Text(
              UserData.userDisplayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: sdp(context, 15),
              ),
            ),
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: primaryAccentColor,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              statusBlocks(),
              itemTimeline(),
              height10,
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: seeMoreButton(
                    context,
                    onTap: () {
                      setState(() {
                        timelineHistoryCounter += 5;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
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
              statsCard(
                onPress: () {},
                icon: Icons.file_upload_outlined,
                cardColor: Color.fromARGB(255, 255, 223, 227),
                label: 'Mortage Principle',
                amount: FutureBuilder<dynamic>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(UserData.uid)
                      .collection('mortgageBill')
                      .where('status', isEqualTo: 'Active')
                      .get(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length > 0) {
                        int totalPrinciple = 0;
                        var dataMap = snapshot.data.docs;
                        for (int index = 0;
                            index < snapshot.data.docs.length;
                            index++) {
                          totalPrinciple +=
                              int.parse(dataMap[index]['amount'].toString());
                        }
                        return Text(
                          "₹ " + Constants.cFInt.format(totalPrinciple),
                          style: TextStyle(
                            fontSize: sdp(context, 13),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text(
                        "₹ 0",
                        style: TextStyle(
                          fontSize: sdp(context, 13),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              statsCard(
                onPress: () {},
                icon: Icons.file_download_outlined,
                cardColor: Color.fromARGB(255, 217, 241, 218),
                label: 'Mortgage Interest',
                amount: FutureBuilder<dynamic>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(UserData.uid)
                        .collection('mortgageBill')
                        .where('status', isEqualTo: 'Active')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length == 0) {
                          return Text(
                            "₹ 0",
                            style: TextStyle(
                                fontSize: sdp(context, 12),
                                fontWeight: FontWeight.bold),
                          );
                        }
                        double totalInterestAmount = 0.0;
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot txnMap = snapshot.data.docs[i];
                          var _calculatedResult = Constants.calculateMortgage(
                            txnMap['weight'],
                            txnMap['purity'],
                            txnMap['amount'],
                            txnMap['interestPerMonth'],
                            txnMap['lastPaymentDate'],
                          );
                          totalInterestAmount +=
                              _calculatedResult['interestAmount'];
                        }
                        return Text(
                          "₹ " +
                              Constants.cFDecimal.format(totalInterestAmount),
                          style: TextStyle(
                              fontSize: sdp(context, 12),
                              fontWeight: FontWeight.bold),
                        );
                      }
                      return SizedBox();
                    }),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              statsCard(
                onPress: () {
                  navPush(context, LowStockUI());
                },
                icon: null,
                cardColor: Color.fromARGB(255, 255, 194, 194),
                label: 'Value of Items',
                amount: Text(
                  "Low Stocks",
                  style: TextStyle(
                      fontSize: sdp(context, 12), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              statsCard(
                onPress: () {
                  navPush(context, LowStockUI());
                },
                icon: null,
                cardColor: Color.fromARGB(255, 255, 194, 194),
                label: 'Mortgage Bills',
                amount: Text(
                  "In Loss",
                  style: TextStyle(
                    fontSize: sdp(context, 12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statsCard({final onPress, label, icon, amount, cardColor}) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: amount),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: sdp(context, 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sdp(context, 10),
                    ),
                    Row(
                      children: [
                        FittedBox(
                          child: Text(
                            label,
                            style: TextStyle(fontSize: sdp(context, 10)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          icon,
                          size: sdp(context, 15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int timelineHistoryCounter = 10;
  Widget itemTimeline() {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(UserData.uid)
          .collection('transactions')
          .orderBy('id', descending: true)
          .limit(timelineHistoryCounter)
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            timelineDateTitle = '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15, left: 0, top: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.timeline,
                          color: Colors.white,
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
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var txnMap = snapshot.data.docs[index];
                    var todayDate = Constants.dateFormat(
                        DateTime.now().millisecondsSinceEpoch);
                    if (timelineDateTitle ==
                        Constants.dateFormat(txnMap['date'])) {
                      showDateWidget = false;
                    } else {
                      timelineDateTitle = Constants.dateFormat(txnMap['date']);
                      showDateWidget = true;
                    }
                    return snapshot.data.docs[index]['type'] ==
                            "StockTransaction"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: showDateWidget,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 5, left: 10),
                                  child: Text(
                                    timelineDateTitle == todayDate
                                        ? "Today"
                                        : timelineDateTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              stockTxnCard(txnMap: txnMap),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: showDateWidget,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 5, left: 10),
                                  child: Text(
                                    timelineDateTitle == todayDate
                                        ? "Today"
                                        : timelineDateTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              mrtgTxnCard(txnMap: txnMap)
                            ],
                          );
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
    );
  }

  Widget stockTxnCard({required var txnMap}) {
    return GestureDetector(
      onTap: () {
        navPush(context, ItemDetailsUI(itemId: txnMap['itemId']))
            .then((value) => setState(() {}));
      },
      child: Container(
        color: Colors.grey.shade100,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${txnMap['itemCategory']}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Remark",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        txnMap['remark'].isEmpty ? 'NA' : txnMap['remark'],
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        txnMap['changeWeight'].toString() +
                            " " +
                            txnMap['unit'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        txnMap['changePiece'].toString() + " PCS",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget mrtgTxnCard({required var txnMap}) {
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
                      "Mortgage",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "${txnMap['description']}",
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Amount Paid",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "₹ " + Constants.cFDecimal.format(txnMap['paidAmount']),
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
}
