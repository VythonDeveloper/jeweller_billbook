import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Mortage/mortgageDetails.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

class MortgageBookUI extends StatefulWidget {
  final mrtgBook;
  const MortgageBookUI({super.key, this.mrtgBook});

  @override
  State<MortgageBookUI> createState() =>
      _MortgageBookUIState(mrtgBook: mrtgBook);
}

class _MortgageBookUIState extends State<MortgageBookUI> {
  final mrtgBook;
  _MortgageBookUIState({this.mrtgBook});

  final _searchKey = TextEditingController();
  List<String> statusList = ['All', 'Active', 'Closed'];
  String _selectedStatus = "All";

  QuerySnapshot<Map<String, dynamic>>? initData;

  @override
  void dispose() {
    super.dispose();
    _searchKey.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: primaryAccentColor,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Text(
                          mrtgBook['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          mrtgBook['phone'],
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryColor,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.call,
                          color: primaryAccentColor,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              mortgageSearchbar(),
              MaterialButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return filterModal();
                      }).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.blueGrey,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Filter"),
                  )),
                ),
              ),
              billList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget mortgageSearchbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: _searchKey,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: primaryColor,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
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

  Widget filterModal() {
    TextStyle headingStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
    );
    return StatefulBuilder(
      builder: ((context, setState) {
        return ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Options',
                    style: headingStyle,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          // controller: ,
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
                                // return Theme(
                                //   data: Theme.of(context).copyWith(
                                //     indicatorColor: Colors.white,
                                //     // colorScheme: ColorScheme.light(
                                //     //   primary: Colors.yellow,
                                //     //   onPrimary: primaryColor,
                                //     //   brightness: Brightness.light,
                                //     //   onSurface: Colors.green,
                                //     //   background: Colors.blue,
                                //     // ),
                                //     scaffoldBackgroundColor: primaryAccentColor,
                                //     // primaryColor: primaryColor,
                                //     iconTheme: IconThemeData(
                                //       color: Colors.white,
                                //     ),
                                //     primaryIconTheme: IconThemeData(
                                //       color: Colors.white,
                                //     ),
                                //     appBarTheme: AppBarTheme(
                                //       backgroundColor: primaryColor,
                                //       foregroundColor: Colors.white,
                                //       actionsIconTheme: IconThemeData(
                                //         color: Colors.white,
                                //       ),
                                //       iconTheme: IconThemeData(
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //     textButtonTheme: TextButtonThemeData(
                                //         // style: TextButton.styleFrom(
                                //         //   backgroundColor: primaryColor,
                                //         // ),
                                //         ),
                                //   ),
                                //   child: child!,
                                // );
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
                          // controller: ,
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
                                // return Theme(
                                //   data: Theme.of(context).copyWith(
                                //     indicatorColor: Colors.white,
                                //     // colorScheme: ColorScheme.light(
                                //     //   primary: Colors.yellow,
                                //     //   onPrimary: primaryColor,
                                //     //   brightness: Brightness.light,
                                //     //   onSurface: Colors.green,
                                //     //   background: Colors.blue,
                                //     // ),
                                //     scaffoldBackgroundColor: primaryAccentColor,
                                //     // primaryColor: primaryColor,
                                //     iconTheme: IconThemeData(
                                //       color: Colors.white,
                                //     ),
                                //     primaryIconTheme: IconThemeData(
                                //       color: Colors.white,
                                //     ),
                                //     appBarTheme: AppBarTheme(
                                //       backgroundColor: primaryColor,
                                //       foregroundColor: Colors.white,
                                //       actionsIconTheme: IconThemeData(
                                //         color: Colors.white,
                                //       ),
                                //       iconTheme: IconThemeData(
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //     textButtonTheme: TextButtonThemeData(
                                //         // style: TextButton.styleFrom(
                                //         //   backgroundColor: primaryColor,
                                //         // ),
                                //         ),
                                //   ),
                                //   child: child!,
                                // );
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
          color: primaryAccentColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget billList() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
            .collection("mortgageBook")
            .doc(mrtgBook['id'].toString())
            .collection('mortgageBill')
            .orderBy('date', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              int dataCounter = 0;
              int loopCounter = 0;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  loopCounter += 1;
                  DocumentSnapshot _txnMap = snapshot.data.docs[index];
                  if (_selectedStatus == 'All') {
                    if (_searchKey.text.isEmpty) {
                      dataCounter++;
                      return billCard(txnMap: _txnMap);
                    } else if (_txnMap['description']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      dataCounter++;
                      return billCard(txnMap: _txnMap);
                    }
                  } else if (_txnMap['status'].toLowerCase() ==
                      _selectedStatus.toLowerCase()) {
                    if (_searchKey.text.isEmpty) {
                      dataCounter++;
                      return billCard(txnMap: _txnMap);
                    } else if (_txnMap['description']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      dataCounter++;
                      return billCard(txnMap: _txnMap);
                    }
                  }

                  if (dataCounter == 0 &&
                      loopCounter == snapshot.data.docs.length) {
                    return Center(
                      child: Text(
                        "No bill found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              );
            }
            return Center(
              child: Text(
                "No Bill. Create...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            );
          }
          return LinearProgressIndicator(
            minHeight: 3,
          );
        });
  }

  Widget billCard({required var txnMap}) {
    return GestureDetector(
      onTap: () {
        PageRouteTransition.push(
            context,
            MortgageBillDetailsUi(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(txnMap['status']),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Total Due",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
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
                      "In Profit",
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Valuation",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
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
            )
          ],
        ),
      ),
    );
  }
}
