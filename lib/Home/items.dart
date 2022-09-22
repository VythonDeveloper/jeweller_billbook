import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Items/createitem.dart';
import 'package:jeweller_billbook/Category/itemcategory.dart';
import 'package:page_transition/page_transition.dart';

class ItemsUi extends StatefulWidget {
  const ItemsUi({Key? key}) : super(key: key);

  @override
  State<ItemsUi> createState() => _ItemsUiState();
}

class _ItemsUiState extends State<ItemsUi> {
  String _selectedCategory = "Gold";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        itemsTitleBar(),
        SizedBox(
          height: 3,
        ),
        itemsSortingBar(),
        itemsList(),
        itemsFloatingButtons(),
      ],
    );
  }

  Widget itemsTitleBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Items",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          Icon(
            Icons.search,
            size: 25,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Low Stock"),
          OutlinedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (BuildContext context,
                        StateSetter setModalState /*You can rename this!*/) {
                      return selectCategoryModal(setModalState);
                    });
                  });
            },
            child: Text("Select Category"),
          ),
        ],
      ),
    );
  }

  Widget itemsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 12),
      child: Column(
        children: List.generate(
            3,
            (index) => itemsCard(
                itemName: "Gold Ring", leftStock: 17.0, salePrice: 2570.3)),
      ),
    );
  }

  Widget itemsCard(
      {required String itemName,
      required double leftStock,
      required double salePrice}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CircleAvatar(
                radius: 18,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(itemName),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(leftStock.toStringAsFixed(2)),
                          Text(
                            "GMS",
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Sale Price"),
                          Text("₹ " + salePrice.toStringAsFixed(2))
                        ],
                      ),
                      Icon(Icons.tune),
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

  Widget itemsFloatingButtons() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.black,
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Create New Item',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: CreateItemUi(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
              ),
            ],
          ),
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
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: ItemCategoryUi(),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            child: Text("Manage Categories"),
          ),
          RadioListTile(
            title: const Text('All Categories'),
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
          RadioListTile(
            title: const Text('Gold'),
            value: "Gold",
            groupValue: _selectedCategory,
            onChanged: (value) {
              print(value.toString());
              setModalState(() {
                _selectedCategory = value.toString();
              });
            },
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
