import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Mortage/mortage_billingUI.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            MortgageAppbar(),
            SizedBox(
              height: 3,
            ),
            mortgageSortingBar(),
            SizedBox(
              height: 3,
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  mortgageList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFABButton(
          onPressed: () {
            PageRouteTransition.push(context, CreateMortgageUi())
                .then((value) => setState(() {}));
          },
          icon: Icons.receipt,
          label: 'Create Mortgage Bill'),
    );
  }

  Widget MortgageAppbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            'Mortgage',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchKey,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.blue.shade700,
                  ),
                  border: InputBorder.none,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget mortgageSortingBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
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

  Widget mortgageList() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("transactions")
            .where('type', isEqualTo: 'MortgageTransaction')
            .orderBy('id', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              int dataCounter = 0;
              int loopCounter = 0;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  loopCounter += 1;
                  DocumentSnapshot _txnMap = snapshot.data.docs[index];
                  if (_selectedStatus == 'All Status') {
                    if (_searchKey.text.isEmpty) {
                      dataCounter++;
                      return mortgageCard(txnMap: _txnMap);
                    } else if (_txnMap['shopName']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      dataCounter++;
                      return mortgageCard(txnMap: _txnMap);
                    }
                  } else if (_txnMap['status'].toLowerCase() ==
                      _selectedStatus.toLowerCase()) {
                    if (_searchKey.text.isEmpty) {
                      dataCounter++;

                      return mortgageCard(txnMap: _txnMap);
                    } else if (_txnMap['shopName']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      dataCounter++;
                      return mortgageCard(txnMap: _txnMap);
                    }
                  }

                  if (dataCounter == 0 &&
                      loopCounter == snapshot.data.docs.length) {
                    return Center(
                      child: Text(
                        "No mortgage found",
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
                "No Mortgage. Create...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            );
          }
          return LinearProgressIndicator(
            minHeight: 3,
          );
        });
  }
}
