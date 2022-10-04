import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Items/editItem.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:flutter/services.dart';

import '../Helper/user.dart';

class ItemDetailsUI extends StatefulWidget {
  final itemId;
  const ItemDetailsUI({super.key, required this.itemId});

  @override
  State<ItemDetailsUI> createState() => _ItemDetailsUIState(itemId: itemId);
}

class _ItemDetailsUIState extends State<ItemDetailsUI> {
  final itemId;
  _ItemDetailsUIState({this.itemId});
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _addStockWeight = TextEditingController();
  final _addStockPiece = TextEditingController();
  final _reduceStockWeight = TextEditingController();
  final _reduceStockPiece = TextEditingController();
  final _transactionType = "StockTransaction";

  @override
  void dispose() {
    super.dispose();
    _addStockWeight.dispose();
    _addStockPiece.dispose();
    _reduceStockWeight.dispose();
    _reduceStockPiece.dispose();
  }

  Map<String, dynamic> itemMap = {
    'id': 0,
    'name': '',
    'code': '',
    'type': '',
    'category': '',
    'unit': '',
    'openingStockWeight': 0.0,
    'openingStockPiece': 0,
    'leftStockWeight': 0.0,
    'leftStockPiece': 0,
    'date': '',
    'lowStockWeight': 0.0,
    'lowStockPiece': 0
  };

  @override
  void initState() {
    super.initState();
    fetchitemDetails();
  }

  Future<void> fetchitemDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('items')
        .doc(itemId.toString())
        .get()
        .then((value) {
      setState(() {
        itemMap = value.data()!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                PageRouteTransition.push(context, EditItemUI(itemMap: itemMap))
                    .then((value) {
                  fetchitemDetails();
                });
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return DeleteItemAlertBox();
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopContent(),
            otherDetailsTabBar(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'btn3',
                  extendedPadding: EdgeInsets.symmetric(horizontal: 50),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AddStockAlertBox();
                      },
                    );
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  backgroundColor: Colors.indigo,
                  extendedIconLabelSpacing: 10,
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Stock',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'btn4',
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return ReduceStockAlertBox();
                      },
                    );
                  },
                  extendedPadding: EdgeInsets.symmetric(horizontal: 50),
                  extendedIconLabelSpacing: 10,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  backgroundColor: Colors.red,
                  icon: Icon(
                    Icons.horizontal_rule_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Stock',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TopContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemMap['name'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Category: ' + itemMap['category'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Text(
                        'View Report',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.indigo,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Left Stock',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              Text(
                itemMap['leftStockWeight'].toStringAsFixed(3) +
                    ' ' +
                    itemMap['unit'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                itemMap['leftStockPiece'].toString() + ' PCS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
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
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                automaticIndicatorColorAdjustment: true,
                indicatorWeight: 2,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'San',
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.indigo,
                tabs: [
                  Tab(text: "Timeline"),
                  Tab(text: "Details"),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ItemTimeline(),
                Details(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ItemTimeline() {
    return Container(
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Activity',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Final Stock',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<dynamic>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserData.uid)
                    .collection('transactions')
                    .where('itemId', isEqualTo: itemMap['id'])
                    .where('type', isEqualTo: _transactionType)
                    .orderBy('id', descending: true)
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var stkTxnMap = snapshot.data.docs[index];
                          return TimelineCard(stkTxnMap: stkTxnMap);
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    );
                  }
                  return LinearProgressIndicator(
                    minHeight: 3,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container TimelineCard({required var stkTxnMap}) {
    String change = stkTxnMap['change'].split("#")[0] +
        '\n' +
        stkTxnMap['change'].split("#")[1];
    String finalStock = stkTxnMap['finalStockWeight'].toStringAsFixed(3) +
        ' ' +
        stkTxnMap['unit'] +
        '\n' +
        stkTxnMap['finalStockPiece'].toString() +
        " PCS";

    bool _isProfit = stkTxnMap['change'].toString().contains('+');
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stkTxnMap['activity'],
                  style: TextStyle(
                    color: _isProfit ? profitColor : lossColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(Constants.dateFormat(stkTxnMap['date'])),
              ],
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.center, child: Text(change)),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                finalStock,
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Details() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Code',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemMap['code'] == '' ? '--' : itemMap['code'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Measuring Unit',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemMap['unit'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Low Stock at',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemMap['lowStockWeight'].toStringAsFixed(3) +
                          ' ' +
                          itemMap['unit'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Type',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemMap['type'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Left Stock',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemMap['leftStockWeight'].toStringAsFixed(3) +
                          ' ' +
                          itemMap['unit'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Left Piece',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemMap['leftStockPiece'].toString() + ' PCS',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AlertDialog AddStockAlertBox() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Stock for',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            itemMap['name'],
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _addStockWeight,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: '0.0',
                    labelText: 'Add Weight',
                    prefixText: '+ ',
                    suffixText: itemMap['unit']),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                ],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is required";
                  }
                  if (double.parse(value) < 0.0) {
                    return "Keep positive";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addStockPiece,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  hintText: '0',
                  labelText: 'Add Piece',
                  prefixText: '+ ',
                  suffixText: "PCS",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is required";
                  }
                  if (int.parse(value) < 0) {
                    return "Keep positive";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            PageRouteTransition.pop(context);
          },
        ),
        TextButton(
          child: const Text('Approve'),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (_formKey1.currentState!.validate()) {
              showLoading(context);
              int uniqueId = DateTime.now().millisecondsSinceEpoch;

              Map<String, dynamic> stkTxnMap = {
                'id': uniqueId,
                'activity': "Add Stock",
                'itemName': itemMap['name'],
                'itemCategory': itemMap['category'],
                'itemId': itemMap['id'],
                'unit': itemMap['unit'],
                'change': '+ ' +
                    double.parse(_addStockWeight.text).toStringAsFixed(3) +
                    ' ' +
                    itemMap['unit'] +
                    '#+ ' +
                    _addStockPiece.text +
                    ' PCS',
                'finalStockWeight': double.parse((itemMap['leftStockWeight'] +
                        double.parse(_addStockWeight.text))
                    .toStringAsFixed(3)),
                'finalStockPiece':
                    itemMap['leftStockPiece'] + int.parse(_addStockPiece.text),
                'type': _transactionType,
                'date': uniqueId
              };

              itemMap['leftStockWeight'] = stkTxnMap['finalStockWeight'];
              itemMap['leftStockPiece'] = stkTxnMap['finalStockPiece'];
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('transactions')
                  .doc(uniqueId.toString())
                  .set(stkTxnMap)
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserData.uid)
                    .collection('items')
                    .doc(itemMap['id'].toString())
                    .update({
                  'leftStockWeight': stkTxnMap['finalStockWeight'],
                  'leftStockPiece': stkTxnMap['finalStockPiece']
                });
                _addStockWeight.clear();
                _addStockPiece.clear();
                PageRouteTransition.pop(context);
                PageRouteTransition.pop(context);
              });
            }
          },
        ),
      ],
    );
  }

  AlertDialog ReduceStockAlertBox() {
    return AlertDialog(
      title: Text('Reduce Stock for ' + itemMap['name']),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _reduceStockWeight,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '0.0',
                      labelText: 'Reduce Weight',
                      prefixText: '- ',
                      suffixText: itemMap['unit']),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,3}')),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This is required";
                    }
                    if (double.parse(value) < 0.0) {
                      return 'Keep positive';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _reduceStockPiece,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: '0',
                    labelText: 'Reduce Piece',
                    prefixText: '- ',
                    suffixText: "PCS",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This is required";
                    }
                    if (int.parse(value) < 0) {
                      return 'Keep positive';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            PageRouteTransition.pop(context);
          },
        ),
        TextButton(
          child: const Text('Approve'),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (_formKey2.currentState!.validate()) {
              showLoading(context);
              int uniqueId = DateTime.now().millisecondsSinceEpoch;

              Map<String, dynamic> stkTxnMap = {
                'id': uniqueId,
                'type': 'StockTransaction',
                'activity': "Reduce Stock",
                'itemName': itemMap['name'],
                'itemCategory': itemMap['category'],
                'itemId': itemMap['id'],
                'unit': itemMap['unit'],
                'change': '- ' +
                    double.parse(_reduceStockWeight.text).toStringAsFixed(3) +
                    ' ' +
                    itemMap['unit'] +
                    '#- ' +
                    _reduceStockPiece.text +
                    ' PCS',
                'finalStockWeight': double.parse((itemMap['leftStockWeight'] -
                        double.parse(_reduceStockWeight.text))
                    .toStringAsFixed(3)),
                'finalStockPiece': itemMap['leftStockPiece'] -
                    int.parse(_reduceStockPiece.text),
                'date': uniqueId
              };

              itemMap['leftStockWeight'] = stkTxnMap['finalStockWeight'];
              itemMap['leftStockPiece'] = stkTxnMap['finalStockPiece'];
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('transactions')
                  .doc(uniqueId.toString())
                  .set(stkTxnMap)
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserData.uid)
                    .collection('items')
                    .doc(itemMap['id'].toString())
                    .update({
                  'leftStockWeight': stkTxnMap['finalStockWeight'],
                  'leftStockPiece': stkTxnMap['finalStockPiece']
                });
                _reduceStockWeight.clear();
                _reduceStockPiece.clear();
                PageRouteTransition.pop(context);
                PageRouteTransition.pop(context);
              });
            }
          },
        ),
      ],
    );
  }

  AlertDialog DeleteItemAlertBox() {
    return AlertDialog(
      title: Text('Delete ' + itemMap['name'] + ' and all transactions?'),
      content: SingleChildScrollView(
        child:
            Text("Deleting will lose all details and transactions till now."),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            PageRouteTransition.pop(context);
          },
        ),
        TextButton(
          child: const Text('Approve'),
          onPressed: () async {
            showLoading(context);

            await FirebaseFirestore.instance
                .collection('users')
                .doc(UserData.uid)
                .collection('items')
                .doc(itemMap['id'].toString())
                .delete()
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('transactions')
                  .where('type', isEqualTo: _transactionType)
                  .where('itemId', isEqualTo: itemMap['id'])
                  .get()
                  .then((value) {
                if (value.size > 0) {
                  value.docs.forEach((element) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(UserData.uid)
                        .collection('transactions')
                        .doc(element['id'].toString())
                        .delete();
                  });
                }
              });
              PageRouteTransition.pop(context);
              PageRouteTransition.pop(context);
              PageRouteTransition.pop(context);
            });
          },
        ),
      ],
    );
  }
}
