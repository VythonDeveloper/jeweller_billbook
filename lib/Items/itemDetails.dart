import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Items/editItem.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';

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
  final _addStockRemark = new TextEditingController();
  final _reduceStockRemark = new TextEditingController();
  final _reduceStockWeight = TextEditingController();
  final _reduceStockPiece = TextEditingController();
  final _transactionType = "StockTransaction";
  final _editStockRemark = new TextEditingController();
  final _editStockWeight = new TextEditingController();
  final _editStockPiece = new TextEditingController();
  double finalStockWeight = 0.0;
  double finalStockPiece = 0.0;

  @override
  void dispose() {
    super.dispose();
    _addStockRemark.dispose();
    _addStockWeight.dispose();
    _addStockPiece.dispose();
    _reduceStockRemark.dispose();
    _reduceStockWeight.dispose();
    _reduceStockPiece.dispose();
    _editStockRemark.dispose();
    _editStockWeight.dispose();
    _editStockPiece.dispose();
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
    'leftStockPiece': 0.0,
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
                navPush(context, EditItemUI(itemMap: itemMap)).then((value) {
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
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'btn11',
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
                  backgroundColor: kAccentColor,
                  extendedIconLabelSpacing: 10,
                  icon: Icon(
                    Icons.add,
                  ),
                  label: Text(
                    'Stock',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'btn12',
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
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: kLightPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                splashBorderRadius: BorderRadius.circular(40),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black.withOpacity(0.4),
                automaticIndicatorColorAdjustment: true,
                indicatorWeight: 2,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  fontFamily: 'San',
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  fontFamily: 'San',
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.black,
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

  int itemHistoryCounter = 5;
  Widget ItemTimeline() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              color: kCardCOlor,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                          color: Colors.black,
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
                          color: Colors.black,
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
                  .limit(itemHistoryCounter)
                  .get(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length > 0) {
                    finalStockPiece =
                        double.parse(itemMap['leftStockPiece'].toString());
                    finalStockWeight =
                        double.parse(itemMap['leftStockWeight'].toString());
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  );
                }
                return LinearProgressIndicator(
                  minHeight: 3,
                );
              }),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: seeMoreButton(
                  context,
                  onTap: () {
                    setState(() {
                      itemHistoryCounter += 5;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget TimelineCard({required var stkTxnMap}) {
    bool _isProfit = !(stkTxnMap['activity'] == "Reduce Stock");
    double leftStockWeight = finalStockWeight;
    double leftStockPiece = finalStockPiece;

    if (_isProfit) {
      finalStockWeight = (finalStockWeight - stkTxnMap['changeWeight']);
      finalStockPiece = finalStockPiece - stkTxnMap['changePiece'];
    } else {
      finalStockWeight = (finalStockWeight + stkTxnMap['changeWeight']);
      finalStockPiece = finalStockPiece + stkTxnMap['changePiece'];
    }
    return GestureDetector(
      onTap: () {
        // showModalBottomSheet<void>(
        //   context: context,
        //   isScrollControlled: true,
        //   builder: (BuildContext context) {
        //     return editStockTransactionModal(stkTxnMap: stkTxnMap);
        //   },
        // );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stkTxnMap['remark'].isEmpty ? "NA" : stkTxnMap['remark'],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text((_isProfit ? '+ ' : '- ') +
                          stkTxnMap['changeWeight'].toStringAsFixed(3) +
                          " " +
                          stkTxnMap['unit']),
                      Text((_isProfit ? '+ ' : '- ') +
                          stkTxnMap['changePiece'].toString() +
                          " PCS"),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      leftStockWeight.toStringAsFixed(3) +
                          " " +
                          stkTxnMap['unit'] +
                          '\n' +
                          leftStockPiece.toStringAsFixed(0) +
                          " PCS",
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                controller: _addStockRemark,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  hintText: 'Add remark',
                  labelText: 'Remark',
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 10),
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
            Navigator.pop(context);
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
                'type': 'StockTransaction',
                'activity': "Add Stock",
                'itemName': itemMap['name'],
                'itemCategory': itemMap['category'],
                'itemId': itemMap['id'],
                'unit': itemMap['unit'],
                'remark': _addStockRemark.text,
                'changeWeight': double.parse(_addStockWeight.text),
                'changePiece': int.parse(_addStockPiece.text),
                'date': uniqueId
              };

              itemMap['leftStockWeight'] = double.parse(
                  (itemMap['leftStockWeight'] +
                          double.parse(_addStockWeight.text))
                      .toStringAsFixed(3));
              itemMap['leftStockPiece'] =
                  itemMap['leftStockPiece'] + int.parse(_addStockPiece.text);

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
                  'leftStockWeight': itemMap['leftStockWeight'],
                  'leftStockPiece': itemMap['leftStockPiece']
                });
                _addStockRemark.clear();
                _addStockWeight.clear();
                _addStockPiece.clear();
                Navigator.pop(context);
                Navigator.pop(context);
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
                  controller: _reduceStockRemark,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Add remark',
                    labelText: 'Remark',
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              SizedBox(height: 10),
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
            Navigator.pop(context);
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
                'remark': _reduceStockRemark.text,
                'changeWeight': double.parse(_reduceStockWeight.text),
                'changePiece': int.parse(_reduceStockPiece.text),
                'date': uniqueId
              };

              itemMap['leftStockWeight'] = double.parse(
                  (itemMap['leftStockWeight'] -
                          double.parse(_reduceStockWeight.text))
                      .toStringAsFixed(3));
              itemMap['leftStockPiece'] =
                  itemMap['leftStockPiece'] - int.parse(_reduceStockPiece.text);

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
                  'leftStockWeight': itemMap['leftStockWeight'],
                  'leftStockPiece': itemMap['leftStockPiece']
                });
                _reduceStockRemark.clear();
                _reduceStockWeight.clear();
                _reduceStockPiece.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          },
        ),
      ],
    );
  }

  // Widget editStockTransactionModal({required var stkTxnMap}) {
  //   _editStockRemark.text = stkTxnMap['remark'];
  //   _editStockWeight.text = stkTxnMap['weight'];
  //   _editStockPiece.text = stkTxnMap['piece'];
  //   return StatefulBuilder(
  //       builder: (BuildContext context, StateSetter setModalState) {
  //     return Container(
  //       margin: EdgeInsets.only(
  //         bottom: MediaQuery.of(context).viewInsets.bottom,
  //       ),
  //       color: Color.fromARGB(255, 255, 255, 255),
  //       child: Form(
  //         key: _formKey3,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(top: 10, left: 10, right: 10),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'Edit Stock Transaction',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Icon(Icons.close),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Divider(),
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 15),
  //               child: TextFormField(
  //                 controller: _editStockRemark,
  //                 autofocus: true,
  //                 decoration: InputDecoration(
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //                   border: OutlineInputBorder(),
  //                   hintText: 'Edit remark',
  //                   labelText: 'Remark',
  //                 ),
  //                 keyboardType: TextInputType.text,
  //                 textCapitalization: TextCapitalization.words,
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 15),
  //               child: TextFormField(
  //                 controller: _editStockWeight,
  //                 decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //                     border: OutlineInputBorder(),
  //                     hintText: '0.0',
  //                     labelText: 'Reduce Weight',
  //                     prefixText:
  //                         stkTxnMap['activity'] == "Reduce Stock" ? '- ' : '+ ',
  //                     suffixText: itemMap['unit']),
  //                 inputFormatters: [
  //                   FilteringTextInputFormatter.allow(
  //                       RegExp(r'^\d+\.?\d{0,3}')),
  //                 ],
  //                 keyboardType: TextInputType.numberWithOptions(decimal: true),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return "This is required";
  //                   }
  //                   if (double.parse(value) < 0.0) {
  //                     return 'Keep positive';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 15),
  //               child: TextFormField(
  //                 controller: _editStockPiece,
  //                 decoration: InputDecoration(
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //                   border: OutlineInputBorder(),
  //                   hintText: '0',
  //                   labelText: 'Reduce Piece',
  //                   prefixText:
  //                       stkTxnMap['activity'] == "Reduce Stock" ? '- ' : '+ ',
  //                   suffixText: "PCS",
  //                 ),
  //                 keyboardType: TextInputType.number,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return "This is required";
  //                   }
  //                   if (int.parse(value) < 0) {
  //                     return 'Keep positive';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Center(
  //               child: MaterialButton(
  //                 onPressed: () async {
  //                   // createItemCategory();
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
  //                   decoration: BoxDecoration(
  //                     color: kPrimaryColor,
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   width: double.infinity,
  //                   child: Center(
  //                     child: Text(
  //                       "Save Changes",
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.white,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 30,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

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
            Navigator.pop(context);
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
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
