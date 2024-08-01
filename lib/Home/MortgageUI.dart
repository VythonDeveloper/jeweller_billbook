import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Mortage/createMrtgBook.dart';
import 'package:jeweller_stockbook/Mortage/MortgageBillUI.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/sdp.dart';
import '../utils/components.dart';

class MortgageUI extends StatefulWidget {
  const MortgageUI({Key? key}) : super(key: key);

  @override
  State<MortgageUI> createState() => _MortgageUIState();
}

class _MortgageUIState extends State<MortgageUI> {
  final _searchKey = TextEditingController();

  QuerySnapshot<Map<String, dynamic>>? initData;

  @override
  void dispose() {
    super.dispose();
    _searchKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mortgage'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            height10,
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    mrtgBookList(),
                    height10,
                    seeMoreButton(context, onTap: () {
                      setState(() {
                        mortgageItemCounter += 5;
                      });
                    }),
                    kHeight(100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFABButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateMrtgBookUi()))
              .then(((value) {
            if (mounted) {
              setState(() {});
            }
          }));
        },
        icon: Icons.book,
        label: '+ Mortgage Book',
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: SearchBar(
        controller: _searchKey,
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),
        leading: Icon(Icons.search),
        hintText: 'Search name, phone etc',
        onChanged: (value) async {
          setState(() {});
        },
      ),
    );
  }

  int mortgageItemCounter = 20;
  Widget mrtgBookList() {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(UserData.uid)
          .collection("mortgageBook")
          .orderBy('id', descending: true)
          .limit(mortgageItemCounter)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot _mrtgBookMap = snapshot.data.docs[index];
                if (kCompare(_mrtgBookMap['name'], _searchKey.text) ||
                    kCompare(_mrtgBookMap['phone'], _searchKey.text))
                  return mrtgBookCard(mrtgBookMap: _mrtgBookMap);
                return SizedBox();
              },
            );
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Text(
                    "No Mortgage",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    "CREATE",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade400,
                      letterSpacing: 5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return LinearProgressIndicator(
          minHeight: 3,
        );
      },
    );
  }

  Widget mrtgBookCard({required var mrtgBookMap}) {
    return GestureDetector(
      onTap: () {
        navPush(context, MortgageBillUI(mrtgBook: mrtgBookMap))
            .then((value) => setState(() {}));
      },
      child: Container(
        color: Colors.grey.shade100,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mrtgBookMap['name'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      mrtgBookMap['phone'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    height10,
                  ],
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade700,
                  child: IconButton(
                    onPressed: () async {
                      Uri url = Uri.parse("tel:${mrtgBookMap['phone']}");
                      if (await canLaunchUrl(url)) {
                        launchUrl(url);
                      } else {
                        kSnackbar(context,
                            'Unable to place call to ${mrtgBookMap['name']}');
                      }
                    },
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: mrtgBookStatsCard(
                      label: 'Total Principle',
                      content: FutureBuilder<dynamic>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserData.uid)
                            .collection('mortgageBill')
                            .where('status', isEqualTo: 'Active')
                            .where('bookId', isEqualTo: mrtgBookMap['id'])
                            .get(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.docs.length > 0) {
                              int totalPrinciple = 0;
                              var dataMap = snapshot.data.docs;
                              for (int index = 0;
                                  index < snapshot.data.docs.length;
                                  index++) {
                                totalPrinciple += int.parse(
                                    dataMap[index]['amount'].toString());
                              }
                              return Text(
                                "₹ " + Constants.cFInt.format(totalPrinciple),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: sdp(context, 10),
                                ),
                              );
                            }
                            return Text(
                              "₹ 0",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: sdp(context, 10),
                              ),
                            );
                          }
                          return Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(),
                          );
                        }),
                      ),
                      mrtgBookMap: mrtgBookMap),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: mrtgBookStatsCard(
                    label: 'Total Interest',
                    content: FutureBuilder<dynamic>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserData.uid)
                            .collection('mortgageBill')
                            .where('status', isEqualTo: 'Active')
                            .where('bookId', isEqualTo: mrtgBookMap['id'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.docs.length == 0) {
                              return Text(
                                "₹ 0",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sdp(context, 10),
                                ),
                              );
                            }
                            double totalInterestAmount = 0.0;
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              DocumentSnapshot txnMap = snapshot.data.docs[i];
                              var _calculatedResult =
                                  Constants.calculateMortgage(
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
                                  Constants.cFDecimal
                                      .format(totalInterestAmount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: sdp(context, 10),
                              ),
                            );
                          }
                          return SizedBox();
                        }),
                    mrtgBookMap: mrtgBookMap,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: mrtgBookStatsCard(
                    label: 'Total Paid',
                    content: Text(
                      "₹ " +
                          Constants.cFDecimal.format(mrtgBookMap['totalPaid']),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sdp(context, 10),
                      ),
                    ),
                    mrtgBookMap: mrtgBookMap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mrtgBookStatsCard({
    final mrtgBookMap,
    label,
    cardColor,
    required Widget content,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kPrimaryColor,
        border: Border.all(color: Colors.amber.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: sdp(context, 10),
            ),
            maxLines: 1,
          ),
          content,
        ],
      ),
    );
  }
}
