import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Items/itemDetails.dart';
import 'package:jeweller_stockbook/Repository/timeline_repo.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:jeweller_stockbook/utils/kScaffold.dart';

class HomeUI extends ConsumerStatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends ConsumerState<HomeUI> {
  bool isLoading = false;
  List<dynamic> transactionsMap = [];
  String timelineDateTitle = '';
  bool showDateWidget = false;
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    final timelineData = ref.watch(timelineFuture(timelineHistoryCounter));
    return KScaffold(
      isLoading: timelineHistoryCounter == 20 && timelineData.isLoading,
      loadingText: "Fetching timeline ...",
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.storefront,
              size: 20,
            ),
            width10,
            Expanded(
              child: Text(
                UserData.userDisplayName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              statusBlocks(),
              itemTimeline(),
              height10,
              if (timelineHistoryCounter > 20 && timelineData.isLoading)
                SizedBox(width: 100, child: LinearProgressIndicator())
              else
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
              height20,
            ],
          ),
        ),
      ),
    );
  }

  Widget statusBlocks() {
    _text(String text) => Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              statsCard(
                onPress: () {},
                icon: Icons.file_upload_outlined,
                cardColor: kPrimaryColor,
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
                        return _text(
                            "₹ " + Constants.cFInt.format(totalPrinciple));
                      }
                      return _text("₹ 0");
                    }
                    return _text("₹ ...");
                  }),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              statsCard(
                onPress: () {},
                icon: Icons.file_download_outlined,
                cardColor: kAccentColor,
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
                          return _text("₹ 0");
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
                        return _text("₹ " +
                            Constants.cFDecimal.format(totalInterestAmount));
                      }
                      return _text("₹ ...");
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
                cardColor: kCardCOlor,
                label: 'Value of Items',
                amount: _text(
                  "Low Stocks",
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
                cardColor: kLightPrimaryColor,
                label: 'Mortgage Bills',
                amount: _text("In Loss"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statsCard({
    void Function()? onPress,
    required String label,
    IconData? icon,
    required Widget amount,
    required Color cardColor,
  }) {
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
                          size: 12,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        FittedBox(
                          child: Text(
                            label,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            icon,
                            size: 20,
                          ),
                        )
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

  int timelineHistoryCounter = 20;
  Widget itemTimeline() {
    return Consumer(
      builder: (context, ref, child) {
        final timelineList = ref.watch(timelineListProvider);
        // ref.watch(timelineFuture(timelineHistoryCounter));

        return Column(
          children: [
            _timelineBar(),
            ListView.separated(
              separatorBuilder: (context, index) => height10,
              itemCount: timelineList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var txnMap = timelineList[index];
                var todayDate =
                    Constants.dateFormat(DateTime.now().millisecondsSinceEpoch);
                if (timelineDateTitle == Constants.dateFormat(txnMap['date'])) {
                  showDateWidget = false;
                } else {
                  timelineDateTitle = Constants.dateFormat(txnMap['date']);
                  showDateWidget = true;
                }
                return timelineList[index]['type'] == "StockTransaction"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: showDateWidget,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 15, top: 20, left: 10),
                              child: Text(
                                timelineDateTitle == todayDate
                                    ? "Today"
                                    : timelineDateTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                  fontSize: 20,
                                ),
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
                                  bottom: 15, top: 20, left: 10),
                              child: Text(
                                timelineDateTitle == todayDate
                                    ? "Today"
                                    : timelineDateTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                    fontSize: 20),
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
      },
    );
  }

  Container _timelineBar() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: kPrimaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.timeline,
            color: Colors.black,
            size: 15,
          ),
          width10,
          Text(
            "Timeline",
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.7,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget stockTxnCard({required var txnMap}) {
    return GestureDetector(
      onTap: () {
        navPush(context, ItemDetailsUI(itemId: txnMap['itemId']))
            .then((value) => setState(() {}));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFD7ECFE),
        ),
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.blue.shade900,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    "${txnMap['itemCategory']}",
                    style: TextStyle(
                      // fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                width10,
                Text(
                  Constants.dateFormat(txnMap['date']),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "${txnMap['itemName']}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          txnMap['remark'].isEmpty ? 'NA' : txnMap['remark'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 12,
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
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          txnMap['changeWeight'].toString() +
                              " " +
                              txnMap['unit'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          txnMap['changePiece'].toString() + " PCS",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mrtgTxnCard({required var txnMap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kColor(context).secondaryContainer,
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: kColor(context).secondary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                'Mortgage',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          color: Colors.black,
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
            ),
          )
        ],
      ),
    );
  }
}
