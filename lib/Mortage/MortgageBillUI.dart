import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Mortage/createMrtgBill.dart';
import 'package:jeweller_stockbook/Mortage/MortgageBillDetailsUI.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:jeweller_stockbook/utils/kScaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/components.dart';

class MortgageBillUI extends StatefulWidget {
  final mrtgBook;
  const MortgageBillUI({super.key, this.mrtgBook});

  @override
  State<MortgageBillUI> createState() =>
      _MortgageBillUIState(mrtgBook: mrtgBook);
}

class _MortgageBillUIState extends State<MortgageBillUI> {
  final mrtgBook;
  _MortgageBillUIState({this.mrtgBook});

  bool isLoading = false;
  final _searchKey = TextEditingController();
  List<String> statusList = ['All', 'Active', 'Closed'];
  // String _selectedStatus = "All";
  Map<String, dynamic> _calculatedResult = {
    "daysSince": 0,
    "interestAmount": 0.0,
    "totalDue": 0.0,
    "valuation": 0.0,
    "profitLoss": 'NA'
  };

  QuerySnapshot<Map<String, dynamic>>? initData;

  @override
  void dispose() {
    super.dispose();
    _searchKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      isLoading: isLoading,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(12),
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: kRadius(10),
                color: kColor(context).surfaceContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mrtgBook['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                        ),
                      ),
                      height5,
                      Text(
                        "Phone: ${mrtgBook['phone']}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  height10,
                  Row(
                    children: [
                      Expanded(
                        child: IconButton.filledTonal(
                          visualDensity: VisualDensity.compact,
                          onPressed: () async {
                            if (!await launchUrl(
                                Uri.parse('tel:${mrtgBook['phone']}'))) {
                              throw Exception(
                                  'Could not launch ${mrtgBook['phone']}');
                            }
                          },
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                size: 12,
                              ),
                              width10,
                              Text("Call"),
                            ],
                          ),
                        ),
                      ),
                      width10,
                      IconButton.filled(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete this book?'),
                              content: Text('Warning! this cannot be undone'),
                              contentTextStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontFamily: 'Product',
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    setState(() {
                                      isLoading = true;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(UserData.uid)
                                        .collection("mortgageBook")
                                        .doc(mrtgBook['id'].toString())
                                        .delete()
                                        .then(
                                      (value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Yes'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade700,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _searchBar(),
                    mrtgBillList(),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMrtgBillUi(
                customerName: mrtgBook['name'],
                phone: mrtgBook['phone'],
                mrtgBookId: mrtgBook['id'],
              ),
            ),
          ).then(((value) {
            if (mounted) {
              setState(() {});
            }
          }));
        },
        icon: Icons.receipt_long,
        label: '+ Create Mortgage Bill',
      ),
    );
  }

  Widget _searchBar() {
    return CupertinoSearchTextField(
      controller: _searchKey,
      // elevation: WidgetStatePropertyAll(0),
      // padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),
      // leading: Icon(Icons.search),
      // backgroundColor: WidgetStatePropertyAll(Colors.white),
      placeholder: 'Search',
      onChanged: (value) async {
        setState(() {});
      },
    );
  }

  Widget mrtgBillSearchBar() {
    return Container(
      padding: EdgeInsets.only(right: 15),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100)),
      child: TextField(
        controller: _searchKey,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
          hintText: 'Search by description',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget mrtgBillfilterModal() {
    TextStyle headingStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
    );
    return StatefulBuilder(
      builder: ((context, setState) {
        return ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                  Text(
                    'Filter Options',
                    style: headingStyle,
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.done),
                    label: Text('Apply'),
                  ),
                  width10,
                ],
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CustomRadioButton(
                        onTap: () {},
                        label: "All",
                      ),
                      CustomRadioButton(
                        onTap: () {},
                        label: "Active",
                      ),
                      CustomRadioButton(
                        onTap: () {},
                        label: "Closed",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Date Range',
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000, 1, 1),
                              lastDate: DateTime.now(),
                              builder: ((context, child) {
                                return Theme(
                                  data: ThemeData.light(
                                    useMaterial3: false,
                                  ),
                                  child: child!,
                                );
                              }),
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'From',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(' - '),
                      ),
                      Flexible(
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000, 1, 1),
                              lastDate: DateTime.now(),
                              builder: ((context, child) {
                                return Theme(
                                  data: ThemeData.light(
                                    useMaterial3: false,
                                  ),
                                  child: child!,
                                );
                              }),
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'To',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Type',
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CustomRadioButton(
                        onTap: () {},
                        label: "All",
                      ),
                      CustomRadioButton(
                        onTap: () {},
                        label: "In Profit",
                      ),
                      CustomRadioButton(
                        onTap: () {},
                        label: "In Loss",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget CustomRadioButton({final label, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kLightPrimaryColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  Widget mrtgBillList() {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(UserData.uid)
          .collection("mortgageBill")
          .where('bookId', isEqualTo: mrtgBook['id'])
          .orderBy('date', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot _txnMap = snapshot.data.docs[index];

                if (kCompare(_txnMap['description'], _searchKey.text) ||
                    kCompare(_txnMap['status'], _searchKey.text)) {
                  return mrtgBillCard(txnMap: _txnMap);
                }

                return SizedBox();
              },
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: 100),
            child: PlaceholderText(text: 'No Bill!'),
          );
        }
        return CustomLoading();
      },
    );
  }

  Widget mrtgBillCard({required var txnMap}) {
    _calculatedResult = Constants.calculateMortgage(
      txnMap['weight'],
      txnMap['purity'],
      txnMap['amount'],
      txnMap['interestPerMonth'],
      txnMap['lastPaymentDate'],
    );

    return GestureDetector(
      onTap: () {
        navPush(
            context,
            MrtgBillDetailsUi(
              mrtgBookId: txnMap['bookId'],
              mrtgBillId: txnMap['id'],
              customerName: mrtgBook['name'],
              phone: mrtgBook['phone'],
            )).then((value) => setState(() {}));
      },
      child: Container(
        color: Colors.grey.shade100,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txnMap['description'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Constants.dateFormat(txnMap['date']),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      decoration: BoxDecoration(
                        color: txnMap['status'] == 'Active'
                            ? Colors.blue.shade700
                            : Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        txnMap['status'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Principle",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "₹ " + Constants.cFDecimal.format(txnMap['amount']),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "In " + _calculatedResult['profitLoss'],
                      style: TextStyle(
                        color: _calculatedResult['profitLoss'] == 'Profit'
                            ? profitColor
                            : lossColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Due",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "₹ " +
                          Constants.cFDecimal
                              .format(_calculatedResult['totalDue']),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
