import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Items/createitem.dart';
import 'package:jeweller_billbook/Category/itemcategory.dart';
import 'package:jeweller_billbook/Items/itemDetails.dart';
import 'package:page_route_transition/page_route_transition.dart';

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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
              onTap: () {},
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

  // Widget itemsList() {
  //   // return Padding(
  //   //   padding: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 12),
  //   //   child: Column(
  //   //     children: List.generate(
  //   //         3,
  //   //         (index) => itemsCard(
  //   //             itemName: "Gold Ring", leftStock: 17.0, salePrice: 2570.3)),
  //   //   ),
  //   // );

  //   return FutureBuilder<dynamic>(
  //     future: FirebaseFirestore.instance
  //         .collection("categories")
  //         .orderBy('id')
  //         .get(),
  //     builder: ((context, snapshot) {
  //       if (snapshot.hasData) {
  //         if (snapshot.data.docs.length > 0) {
  //           ListView.builder(
  //             itemCount: snapshot.data.docs.length,
  //             itemBuilder: (context, index) {
  //               return itemsCard(
  //                   itemName: snapshot.data.docs[index]['name'],
  //                   leftStock: snapshot.data.docs[index]['openingStock']);
  //             },
  //           );
  //         }
  //         return Text("No Itemsff");
  //       }
  //       return Container(child: CircularProgressIndicator());
  //     }),
  //   );
  // }

  Widget itemsList() {
    return FutureBuilder<dynamic>(
        future:
            FirebaseFirestore.instance.collection("items").orderBy('id').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    int id = snapshot.data.docs[index]['id'];
                    String name = snapshot.data.docs[index]['name'];
                    String unit = snapshot.data.docs[index]['unit'];
                    if (_searchKey.text.isEmpty) {
                      return itemsCard(id: id, itemName: name, unit: unit);
                    } else {
                      if (name
                          .toLowerCase()
                          .contains(_searchKey.text.toLowerCase())) {
                        return itemsCard(id: id, itemName: name, unit: unit);
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

  Widget itemsCard(
      {required int id, required String itemName, required String unit}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 18,
            child: Text(itemName[0]),
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
                  itemName,
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
                    Text("100 " + unit),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              PageRouteTransition.push(context, ItemDetailsUI(id: id));
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
