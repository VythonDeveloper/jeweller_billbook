import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Items/createitem.dart';
import 'package:jeweller_stockbook/Category/itemcategory.dart';
import 'package:jeweller_stockbook/Items/itemDetails.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';

class ItemsUi extends StatefulWidget {
  const ItemsUi({Key? key}) : super(key: key);

  @override
  State<ItemsUi> createState() => _ItemsUiState();
}

class _ItemsUiState extends State<ItemsUi> {
  final _searchKey = TextEditingController();
  List<String> categoryList = ['All Categories'];
  String _selectedCategory = "All Categories";

  QuerySnapshot<Map<String, dynamic>>? initData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: sdp(context, 75),
        title: appBarItems(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                  ),
                ),
                width10,
                Expanded(
                  child: SingleChildScrollView(
                    child: totalWeightList(),
                  ),
                ),
              ],
            ),
            height10,
            itemsList(),
          ],
        ),
      ),
      floatingActionButton: CustomFABButton(
          onPressed: () {
            navPush(context, CreateItemUi()).then((value) => setState(() {}));
          },
          icon: Icons.add,
          label: 'Add Item'),
    );
  }

  Widget appBarItems() {
    return Column(
      children: [
        Text('Items'),
        // searchBar(),
        height10,
        itemsSortingBar(),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: primaryAccentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.5)),
      ),
      child: TextField(
        controller: _searchKey,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: primaryColor,
          ),
          border: InputBorder.none,
          hintText: 'Search by Name',
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: sdp(context, 10),
          ),
        ),
        onChanged: (value) {
          // setState(() {});
        },
      ),
    );
  }

  Widget itemsSortingBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                  context: context,
                  isDismissible: false,
                  builder: (BuildContext context) {
                    return selectCategoryModal();
                  }).then((value) {
                setState(() {});
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategory,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: sdp(context, 10)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 15,
                    color: Colors.white,
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
              navPush(context, LowStockUI());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 15,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Low Stock',
                        style: TextStyle(
                            fontSize: sdp(context, 10),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget totalWeightList() {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(UserData.uid)
          .collection('items')
          .orderBy('id', descending: true)
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            Map<String, dynamic> totalWeightMap = {};
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              var itemMap = snapshot.data.docs[i];
              if (totalWeightMap[itemMap['category']] != null) {
                totalWeightMap[itemMap['category']] +=
                    double.parse(itemMap['leftStockWeight'].toStringAsFixed(3));
                ;
              } else {
                totalWeightMap[itemMap['category']] =
                    double.parse(itemMap['leftStockWeight'].toStringAsFixed(3));
              }
            }
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: List.generate(
                  totalWeightMap.keys.length,
                  (index) {
                    String key = totalWeightMap.keys.elementAt(index);
                    return totalWeightCard(
                      key: key,
                      totalWeight: totalWeightMap[key],
                    );
                  },
                ),
              ),
            );
          }
          return Text('Create category');
        }
        return LinearProgressIndicator();
      }),
    );
  }

  Widget totalWeightCard({required String key, required double totalWeight}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          Text(
            "Wt. " + totalWeight.toStringAsFixed(3) + " GMS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget itemsList() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
            .collection("items")
            .orderBy('id', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              int dataCounter = 0;
              int loopCounter = 0;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  loopCounter += 1;
                  DocumentSnapshot _txnMap = snapshot.data.docs[index];
                  if (_selectedCategory == 'All Categories') {
                    if (_searchKey.text.isEmpty) {
                      dataCounter++;
                      return itemsCard(itemMap: _txnMap);
                    } else if (_txnMap['name']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      dataCounter++;
                      return itemsCard(itemMap: _txnMap);
                    }
                  } else if (_txnMap['category'].toLowerCase() ==
                      _selectedCategory.toLowerCase()) {
                    if (_searchKey.text.isEmpty) {
                      dataCounter++;
                      return itemsCard(itemMap: _txnMap);
                    } else if (_txnMap['name']
                        .toLowerCase()
                        .contains(_searchKey.text.toLowerCase())) {
                      dataCounter++;
                      return itemsCard(itemMap: _txnMap);
                    }
                  }

                  if (dataCounter == 0 &&
                      loopCounter == snapshot.data.docs.length) {
                    return Center(
                      child: Text(
                        "No item found",
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
            return PlaceholderText(text1: "No Items", text2: 'CREATED');
          }
          return LinearProgressIndicator(
            minHeight: 3,
          );
        });
  }

  Widget itemsCard({required var itemMap}) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        navPush(context, ItemDetailsUI(itemId: itemMap['id']))
            .then((value) => setState(() {}));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 18,
              child: Text(
                itemMap['name'][0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Left Weight:",
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            itemMap['leftStockWeight'].toStringAsFixed(3) +
                                ' ' +
                                itemMap['unit'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Piece:",
                            maxLines: 2,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            itemMap['leftStockPiece'].toString() + ' PCS',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Spacer(),
            // IconButton(
            //   onPressed: () {
            //     FocusScope.of(context).unfocus();
            //     navPush(context, ItemDetailsUI(itemId: itemMap['id']))
            //         .then((value) {
            //       if (mounted) {
            //         setState(() {});
            //       }
            //     });
            //   },
            //   icon: Icon(
            //     Icons.settings,
            //     size: 17,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget selectCategoryModal() {
    return StatefulBuilder(builder: (context, StateSetter setModalState) {
      return SafeArea(
        top: false,
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Item Category',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                        navPush(context, ItemCategoryUi())
                            .then((value) => setModalState(() {}));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: primaryColor,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                            ? primaryAccentColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RadioListTile(
                        title: Text("All Categories"),
                        value: "All Categories",
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setModalState(() {
                            _selectedCategory = value.toString();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    categoriesRadioList(setModalState),
                  ],
                ),
              ),
            ],
          ),
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
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == categoryName
                            ? primaryAccentColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RadioListTile(
                        title: Text(categoryName),
                        value: categoryName,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setModalState(() {
                            _selectedCategory = value.toString();
                            Navigator.pop(context);
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
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomLoading(indicatorColor: primaryColor),
        );
      },
    );
  }
}
