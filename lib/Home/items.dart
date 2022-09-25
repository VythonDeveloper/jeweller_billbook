import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Items/createitem.dart';
import 'package:jeweller_billbook/Category/itemcategory.dart';
import 'package:jeweller_billbook/Items/itemDetails.dart';
import 'package:jeweller_billbook/Services/user.dart';
import 'package:jeweller_billbook/Stock/lowStock.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';

class ItemsUi extends StatefulWidget {
  const ItemsUi({Key? key}) : super(key: key);

  @override
  State<ItemsUi> createState() => _ItemsUiState();
}

class _ItemsUiState extends State<ItemsUi> {
  final _searchKey = TextEditingController();
  List<String> categoryList = ['All Categories'];
  String _selectedCategory = "All Categories";

  @override
  void initState() {
    super.initState();
    _firebaseItems();
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

  QuerySnapshot<Map<String, dynamic>>? initData;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _firebaseItems() async {
    final SharedPreferences prefs = await _prefs;
    UserData.uid == ''
        ? UserData.uid = prefs.getString('USERKEY')!
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
            .collection("items")
            .orderBy('id')
            .get()
            .then((value) {
            initData = value;
            setState(() {});
          });

    setState(() {});
  }

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
                  itemsList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFABButton(
          onPressed: () {
            PageRouteTransition.push(context, CreateItemUi())
                .then((value) => setState(() {}));
          },
          icon: Icons.add,
          label: 'Add Item'),
    );
  }

  Widget ItemsAppbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            'Items',
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
                      Icons.production_quantity_limits,
                      color: Colors.redAccent,
                      size: 15,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Low Stock',
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

  Widget itemsList() {
    return FutureBuilder<dynamic>(
        future: initData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var itemMap = snapshot.data.docs[index];

                    if (_searchKey.text.isEmpty) {
                      return itemsCard(itemMap: itemMap);
                    } else {
                      if (itemMap['name']
                          .toLowerCase()
                          .contains(_searchKey.text.toLowerCase())) {
                        return itemsCard(itemMap: itemMap);
                      }
                    }
                    return SizedBox();
                  });
            } else {
              return Text("No Category");
            }
          }
          return LinearProgressIndicator(
            minHeight: 3,
          );
        });
  }

  Widget itemsCard({required var itemMap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 18,
            child: Text(itemMap['name'][0]),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemMap['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stock:",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      itemMap['leftStock'].toStringAsFixed(2) +
                          ' ' +
                          itemMap['unit'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              PageRouteTransition.push(
                      context, ItemDetailsUI(itemId: itemMap['id']))
                  .then((value) => setState(() {}));
            },
            icon: Icon(
              Icons.tune,
              size: 17,
              color: Colors.black,
            ),
          ),
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
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                    print('_selectedCategory - ' + _selectedCategory);
                  });
                },
              ),
            ),
            categoriesRadioList(setModalState),
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
          .doc(UserData.uid)
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
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
        }
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
