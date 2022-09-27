import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/Services/user.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

class EditItemUI extends StatefulWidget {
  final itemMap;
  const EditItemUI({Key? key, required this.itemMap}) : super(key: key);

  @override
  State<EditItemUI> createState() => _EditItemUIState(itemMap: itemMap);
}

class _EditItemUIState extends State<EditItemUI> {
  final itemMap;
  _EditItemUIState({required this.itemMap});

  int uniqueId = DateTime.now().millisecondsSinceEpoch;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<String> categoryList = ['No Category'];
  String _selectedCategory = "No Category";
  String _selectedUnit = Constants.unitList[0];
  final ValueNotifier<bool> _lowStockToggle = ValueNotifier<bool>(false);
  String _selectedItemType = "Product";
  final _itemName = new TextEditingController();
  final _itemCode = new TextEditingController();
  final _openingStockWeight = new TextEditingController();
  final _openingStockPiece = new TextEditingController();
  final _date = new TextEditingController();
  final _lowStockWeight = new TextEditingController();
  final _lowStockPiece = new TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _itemName.text = itemMap['name'];
    _itemCode.text = itemMap['code'];
    _selectedItemType = itemMap['type'];
    _selectedUnit = itemMap['unit'];
    _openingStockWeight.text = itemMap['openingStockWeight'].toString();
    _openingStockPiece.text = itemMap['openingStockPiece'].toString();
    _date.text = itemMap['date'];
    if (itemMap['lowStockWeight'] > 0.0 || itemMap['lowStockPiece'] > 0) {
      _lowStockToggle.value = !_lowStockToggle.value;
    }
    _lowStockWeight.text = itemMap['lowStockWeight'].toString();
    _lowStockPiece.text = itemMap['lowStockPiece'].toString();
  }

  @override
  void dispose() {
    super.dispose();
    _itemName.dispose();
    _itemCode.dispose();
    _openingStockWeight.dispose();
    _openingStockPiece.dispose();
    _date.dispose();
    _lowStockWeight.dispose();
    _lowStockPiece.dispose();
  }

  fetchCategories() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('categories')
        .orderBy('id')
        .get()
        .then((value) {
      if (value.size > 0) {
        for (int index = 0; index < value.size; index++)
          categoryList.add(value.docs[index]['name']);
      }
    });
    setState(() {
      _selectedCategory = itemMap['category'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              basicItemDetails(),
              SizedBox(
                height: 10,
              ),
              otherDetailsTabBar(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomFABButton(
          onPressed: () {
            if (_formKey1.currentState!.validate() &&
                _formKey2.currentState!.validate()) {
              showLoading(context);
              Map<String, dynamic> updatedItemMap = {
                'name': _itemName.text,
                'code': _itemCode.text,
                'type': _selectedItemType,
                'category': _selectedCategory,
                'unit': _selectedUnit,
                'date': _date.text,
                'lowStockWeight': double.parse(_lowStockWeight.text),
                'lowStockPiece': int.parse(_lowStockPiece.text)
              };
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('items')
                  .doc(itemMap['id'].toString())
                  .update(updatedItemMap)
                  .then((value) {
                PageRouteTransition.pop(context);
                PageRouteTransition.pop(context);
              });
            }
          },
          icon: Icons.done,
          label: 'Save',
        ),
      ),
    );
  }

  Widget basicItemDetails() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _itemName,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
                label: Text("Item Name"),
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This is required';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _itemCode,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
                label: Text("Item Code"),
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.characters,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text("Item Type"),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItemType = "Product";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: _selectedItemType == "Product"
                          ? Colors.indigo
                          : Color.fromARGB(255, 220, 226, 255),
                    ),
                    child: Text(
                      "Product",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _selectedItemType == "Product"
                            ? Colors.white
                            : Colors.indigo,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItemType = "Service";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: _selectedItemType == "Service"
                          ? Colors.indigo
                          : Color.fromARGB(255, 220, 226, 255),
                    ),
                    child: Text(
                      "Service",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _selectedItemType == "Service"
                            ? Colors.white
                            : Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget otherDetailsTabBar() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: AppBar(
              bottom: TabBar(
                automaticIndicatorColorAdjustment: true,
                indicatorWeight: 2,
                indicatorColor: Colors.indigo,
                tabs: [
                  Tab(
                    child: Text(
                      "Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Stock",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                categoryTabBar(),
                stockTabBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryTabBar() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Category"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isDense: true,
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
                      _selectedCategory = value!;
                    });
                  },
                  items: categoryList
                      .map<DropdownMenuItem<String>>((String value) {
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
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Unit"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  value: _selectedUnit,
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
                      _selectedUnit = value!;
                    });
                  },
                  items: Constants.unitList
                      .map<DropdownMenuItem<String>>((String value) {
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
            ],
          ),
        ],
      ),
    );
  }

  Widget stockTabBar() {
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey2,
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Opening Stock"),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _openingStockWeight,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: '0.0',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      suffixText: _selectedUnit,
                      label: Text("Weight"),
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,3}')),
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _openingStockWeight.text = '0.0';
                        return 'This is required';
                      }
                      if (double.parse(value) < 0.0) {
                        return 'Keep positive value';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _openingStockPiece,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: '0',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      suffixText: "PCS",
                      label: Text("Piece"),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _openingStockPiece.text = '0';
                        return 'This is required';
                      }
                      if (int.parse(value) < 0) {
                        return 'Keep positive value';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              readOnly: true,
              controller: _date,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                label: Text("As of Date"),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _lowStockToggle.value = !_lowStockToggle.value;
                  _lowStockWeight.text = '0.0';
                  _lowStockPiece.text = '0';
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: _lowStockToggle.value
                      ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                      : BorderRadius.circular(10),
                  color: _lowStockToggle.value
                      ? Color.fromARGB(255, 230, 233, 253)
                      : Colors.grey.shade100,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Low Stock Alert",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: _lowStockToggle.value
                            ? Colors.indigo.shade700
                            : Colors.black,
                      ),
                    ),
                    Transform.scale(
                      scale: 1.1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            _lowStockToggle.value = !_lowStockToggle.value;
                            _lowStockWeight.text = '0.0';
                            _lowStockPiece.text = '0';
                          });
                        },
                        value: _lowStockToggle.value,
                        activeColor: Colors.indigoAccent,
                        activeTrackColor: Colors.indigo.shade100,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 100),
              child: ValueListenableBuilder<bool>(
                valueListenable: _lowStockToggle,
                builder: ((context, lowStockToggle, child) {
                  return lowStockToggle
                      ? Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 237, 240, 255),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Low Stock Quantity',
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.white,
                                      child: TextFormField(
                                        controller: _lowStockWeight,
                                        decoration: InputDecoration(
                                          label: Text("Alert Weight"),
                                          hintText: '0.0',
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          suffixText: _selectedUnit,
                                          border: OutlineInputBorder(),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,3}')),
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            _lowStockWeight.text = '0.0';
                                          }
                                          if (double.parse(value!) < 0.0) {
                                            return 'Keep positive value';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.white,
                                      child: TextFormField(
                                        controller: _lowStockPiece,
                                        decoration: InputDecoration(
                                          hintText: '0',
                                          label: Text("Alert Piece"),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          suffixText: "PCS",
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            _lowStockPiece.text = '0';
                                          }
                                          if (int.parse(value!) < 0) {
                                            return 'Keep positive value';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'You will be notified when stock goes below ' +
                                      _lowStockWeight.text +
                                      ' ' +
                                      _selectedUnit +
                                      ' or ' +
                                      _lowStockPiece.text +
                                      ' PCS',
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
