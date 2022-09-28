import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Category/itemcategory.dart';
import 'package:jeweller_stockbook/Mortage/mortage_billingUI.dart';
import 'package:jeweller_stockbook/Services/user.dart';
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
  List<String> categoryList = ['All Status', "Active", "Closed"];
  String _selectedCategory = "All Status";

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
            SizedBox(
              height: 10,
            ),
            ItemsAppbar(),
            SizedBox(
              height: 3,
            ),
            itemsSortingBar(),
            SizedBox(
              height: 10,
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

  Widget ItemsAppbar() {
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

  Widget itemsSortingBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return selectCategoryModal();
                    }).then((value) {
                  setState(() {});
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 15,
                    ),
                  ],
                ),
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
            .doc(UserData.uid)
            .collection("transactions")
            .where('type', isEqualTo: 'MortgageTransaction')
            .orderBy('id', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var itemMap = snapshot.data.docs[index];

                    if (itemMap['shopName']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      return mortgageCard(txnMap: itemMap);
                    }
                    return SizedBox();
                  });
            }
            return Center(
              child: Text(
                "No Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            );
          }
          return LinearProgressIndicator(
            minHeight: 3,
          );
        });
  }

  Widget mortgageCard({required var txnMap}) {
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
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${txnMap['shopName']}",
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
                      txnMap['status'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: txnMap['status'] == "Active"
                            ? Color.fromARGB(255, 76, 135, 175)
                            : Color.fromARGB(255, 247, 122, 20),
                        fontSize: 13,
                      ),
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
                      "₹ " + txnMap['amount'].toStringAsFixed(2),
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
                      "In Profit",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: txnMap['status'] == "Active"
                            ? Colors.green
                            : Colors.red,
                        fontSize: 13,
                      ),
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
                      "20",
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

  Widget selectCategoryModal() {
    return StatefulBuilder(builder: (context, StateSetter setModalState) {
      return Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Item Category'),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      PageRouteTransition.push(context, ItemCategoryUi())
                          .then((value) => setModalState(() {}));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.indigo,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    child: Text(
                      "Manage Categories",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: _selectedCategory == 'All Categories'
                          ? Colors.indigo.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RadioListTile(
                      title: Text("All Categories"),
                      value: "All Categories",
                      groupValue: _selectedCategory,
                      onChanged: (value) {
                        print(value.toString());
                        setModalState(() {
                          _selectedCategory = value.toString();
                          // print('_selectedCategory - ' + _selectedCategory);
                        });
                      },
                    ),
                  ),
                  categoriesRadioList(setModalState),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }

  Widget categoriesRadioList(StateSetter setModalState) {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('categories')
          .orderBy('id')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) {
                String categoryName = snapshot.data.docs[index]['name'];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == categoryName
                            ? Colors.indigo.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RadioListTile(
                        title: Text(categoryName),
                        value: categoryName,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          print(value.toString());
                          setModalState(() {
                            _selectedCategory = value.toString();
                            print('_selectedCategory - ' + _selectedCategory);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            );
          }
          return SizedBox();
        }
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
