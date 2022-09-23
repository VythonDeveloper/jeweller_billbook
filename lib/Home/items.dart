import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Items/createitem.dart';
import 'package:jeweller_billbook/Category/itemcategory.dart';
import 'package:jeweller_billbook/Items/itemDetails.dart';
import 'package:page_route_transition/page_route_transition.dart';

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
    PageRouteTransition.effect = TransitionEffect.fade;
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
                  itemsList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          PageRouteTransition.push(context, CreateItemUi())
              .then((value) => setState(() {}));
        },
        elevation: 2,
        heroTag: 'btn2',
        icon: Icon(Icons.add),
        label: Text('Add Item'),
      ),
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
                      return StatefulBuilder(builder: (BuildContext context,
                          StateSetter setModalState /*You can rename this!*/) {
                        return selectCategoryModal(setModalState);
                      });
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
          return CircularProgressIndicator();
        });
  }

  Widget itemsCard(
      {required int id, required String itemName, required String unit}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10.0),
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
      ),
    );
  }

  Widget selectCategoryModal(StateSetter setModalState) {
    return Container(
      // height: 200,
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Item category'),
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
          OutlinedButton(
            onPressed: () {
              PageRouteTransition.push(context, ItemCategoryUi())
                  .then((value) => setModalState(() {}));
            },
            child: Text("Manage Categories"),
          ),
          RadioListTile(
            title: Text("All Categories"),
            value: "All Categories",
            groupValue: _selectedCategory,
            onChanged: (value) {
              print(value.toString());
              setModalState(() {
                _selectedCategory = value.toString();
              });
            },
          ),
          Divider(),
          categoriesRadioList(setModalState),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget categoriesRadioList(StateSetter setModalState) {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('categories')
          .orderBy('id')
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) {
                String categoryName = snapshot.data.docs[index]['name'];
                return Column(
                  children: [
                    RadioListTile(
                      title: Text(categoryName),
                      value: categoryName,
                      groupValue: _selectedCategory,
                      onChanged: (value) {
                        print(value.toString());
                        setModalState(() {
                          _selectedCategory = value.toString();
                        });
                      },
                    ),
                    Divider(),
                  ],
                );
              }),
            );
          }
        }
        return CircularProgressIndicator();
      }),
    );
  }
}
