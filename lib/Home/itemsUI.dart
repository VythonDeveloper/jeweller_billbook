import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Items/createitem.dart';
import 'package:jeweller_stockbook/Category/itemcategory.dart';
import 'package:jeweller_stockbook/Items/itemDetails.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';

class ItemsUI extends StatefulWidget {
  const ItemsUI({Key? key}) : super(key: key);

  @override
  State<ItemsUI> createState() => _ItemsUIState();
}

class _ItemsUIState extends State<ItemsUI> {
  final _searchKey = TextEditingController();
  List<String> categoryList = ['All Categories'];
  String _selectedCategory = "All Categories";

  QuerySnapshot<Map<String, dynamic>>? initData;
  bool _isSearching = false;
  QuerySnapshot<Map<String, dynamic>>? searchedItemList;

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
        toolbarHeight: sdp(context, 78),
        title: appBarItems(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
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
                      padding: EdgeInsets.only(right: 10),
                      scrollDirection: Axis.horizontal,
                      child: totalWeightList(),
                    ),
                  ),
                ],
              ),
            ),
            height10,
            _isSearching
                ? searchedItemList != null
                    ? searchedList()
                    : SizedBox()
                : itemsList(),
            seeMoreButton(context, onTap: () {
              setState(() {
                itemsCounter += 5;
              });
            }),
            height50,
            height50,
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

  Widget searchedList() {
    return ListView.separated(
      separatorBuilder: (context, index) => height10,
      itemCount: searchedItemList!.size,
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return itemsCard(itemMap: searchedItemList!.docs[index].data());
      },
    );
  }

  Widget appBarItems() {
    return Column(
      children: [
        _searchBar(),
        height10,
        itemsSortingBar(),
      ],
    );
  }

  Widget _searchBar() {
    return SearchBar(
      controller: _searchKey,
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),
      leading: Icon(Icons.search),
      hintText: 'Search',
      onChanged: (value) async {
        if (value.length >= 3) {
          _isSearching = true;
          searchedItemList = await FirebaseFirestore.instance
              .collection('users')
              .doc(UserData.uid)
              .collection("items")
              .where('name', isGreaterThanOrEqualTo: value)
              .where('name', isLessThanOrEqualTo: value + '\uf8ff')
              .get();
        } else {
          _isSearching = false;
        }
        setState(() {});
      },
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
                color: kCardCOlor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategory,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sdp(context, 10)),
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
        return SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: LinearProgressIndicator(),
        );
      }),
    );
  }

  Widget totalWeightCard({required String key, required double totalWeight}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          Text(
            "Wt. " + totalWeight.toStringAsFixed(3) + " GMS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  int itemsCounter = 5;
  Widget itemsList() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
            .collection("items")
            .orderBy('id', descending: true)
            .limit(itemsCounter)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              int dataCounter = 0;
              int loopCounter = 0;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),
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
          color: kTileColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kTileBorderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: kCardCOlor,
              radius: 18,
              child: Text(
                itemMap['name'][0],
                style: TextStyle(
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
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          navPush(context, ItemCategoryUi())
                              .then((value) => setModalState(() {}));
                        },
                        child: Text('Manage Categories')),
                    height15,
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == 'All Categories'
                            ? kLightPrimaryColor
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
          .limit(5)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            return ListView.separated(
              separatorBuilder: (context, index) => height10,
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
                            ? kLightPrimaryColor
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
          child: CustomLoading(indicatorColor: kPrimaryColor),
        );
      },
    );
  }
}
