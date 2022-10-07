import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Mortage/contactCrud.dart';
import 'package:jeweller_stockbook/Mortage/createmortgage.dart';
import 'package:jeweller_stockbook/Mortage/mortgageBookUI.dart';
import 'package:jeweller_stockbook/Mortage/mortgageDetails.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../components.dart';

class MortgageUi extends StatefulWidget {
  const MortgageUi({Key? key}) : super(key: key);

  @override
  State<MortgageUi> createState() => _MortgageUiState();
}

class _MortgageUiState extends State<MortgageUi> {
  final _searchKey = TextEditingController();
  List<String> statusList = ['All Status', "Active", "Closed"];
  String _selectedStatus = "All Status";

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
      ),
      body: SafeArea(
        child: Column(
          children: [
            MortgageSearchbar(),
            SizedBox(
              height: 3,
            ),
            // mortgageSortingBar(),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  mortgageList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFABButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactCrudUI()))
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

  Widget MortgageSearchbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
          hintText: 'Search by name',
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

  Widget mortgageSortingBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor,
                ),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                isDense: true,
                value: _selectedStatus,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 17,
                ),
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                underline: Container(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                items: statusList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                PageRouteTransition.push(context, LowStockUI());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_down,
                      color: Colors.redAccent,
                      size: 15,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'In Loss',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  Widget mortgageList() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("mortgage")
            .orderBy('id', descending: true)
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
                  return mortgageBookCard(mrtgBookMap: _mrtgBookMap);
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
        });
  }

  Widget mortgageBookCard({required var mrtgBookMap}) {
    return GestureDetector(
      onTap: () {
        PageRouteTransition.push(context, MortgageBookUI(mrtgBook: mrtgBookMap))
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MortgageBookStatsCard(
                      label: 'Principle Amount',
                      cardColor: Colors.blueGrey.shade500,
                      content: "₹ " +
                          Constants.cFDecimal
                              .format(mrtgBookMap['totalPrincipal']),
                      mrtgBookMap: mrtgBookMap),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: MortgageBookStatsCard(
                      label: 'Due Amount',
                      cardColor: Colors.blueGrey.shade700,
                      content: "₹ " +
                          Constants.cFDecimal
                              .format(mrtgBookMap['totalPrincipal']),
                      mrtgBookMap: mrtgBookMap),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: MortgageBookStatsCard(
                      label: 'Principle Amount',
                      cardColor: Colors.blueGrey.shade900,
                      content: "₹ " +
                          Constants.cFDecimal
                              .format(mrtgBookMap['totalPrincipal']),
                      mrtgBookMap: mrtgBookMap),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container MortgageBookStatsCard(
      {final mrtgBookMap, label, cardColor, content}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          FittedBox(
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
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
}
