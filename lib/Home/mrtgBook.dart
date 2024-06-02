import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Mortage/createMrtgBook.dart';
import 'package:jeweller_stockbook/Mortage/mrtgBill.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/sdp.dart';
import '../utils/components.dart';

class MortgageUi extends StatefulWidget {
  const MortgageUi({Key? key}) : super(key: key);

  @override
  State<MortgageUi> createState() => _MortgageUiState();
}

class _MortgageUiState extends State<MortgageUi> {
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
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              mrtgBookList(),
              height10,
              seeMoreButton(context, onTap: () {
                setState(() {
                  mortgageItemCounter += 5;
                });
              }),
              height50,
              height50,
            ],
          ),
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

  Widget appBarItems() {
    return Row(
      children: [
        Text(
          'Mortgage',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: sdp(context, 12),
          ),
        ),
        // width5,
        // Flexible(
        //   child: searchBar(),
        // ),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchKey,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          border: InputBorder.none,
          hintText: 'Search by name',
          // hintStyle: TextStyle(
          //   color: Colors.grey.shade700,
          //   fontSize: sdp(context, 10),
          // ),
        ),
        onChanged: (value) {
          // setState(() {});
        },
      ),
    );
  }

  int mortgageItemCounter = 5;
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
                return mrtgBookCard(mrtgBookMap: _mrtgBookMap);
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
        navPush(context, MrtgBillUi(mrtgBook: mrtgBookMap))
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
                    SizedBox(
                      height: 10,
                    ),
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
                        showSnackBar(context,
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
