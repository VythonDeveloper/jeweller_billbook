import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Items/editItem.dart';
import 'package:jeweller_billbook/components.dart';
import 'package:page_route_transition/page_route_transition.dart';

class ItemDetailsUI extends StatefulWidget {
  final itemId;
  const ItemDetailsUI({super.key, required this.itemId});

  @override
  State<ItemDetailsUI> createState() => _ItemDetailsUIState(itemId: itemId);
}

class _ItemDetailsUIState extends State<ItemDetailsUI> {
  final itemId;
  _ItemDetailsUIState({this.itemId});
  final _formKey = GlobalKey<FormState>();
  final _addStockQuantity = TextEditingController();
  final _reduceStockQuantity = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _addStockQuantity.dispose();
    _reduceStockQuantity.dispose();
  }

  Map<String, dynamic> itemMap = {
    'id': '',
    'name': '',
    'code': '',
    'type': '',
    'category': '',
    'unit': '',
    'openingStock': 0.0,
    'leftStock': 0.0,
    'date': '',
    'lowStock': 0.0
  };

  @override
  void initState() {
    super.initState();
    print(itemId);
    fetchitemDetails();
  }

  Future<void> fetchitemDetails() async {
    await FirebaseFirestore.instance
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
          actions: [
            IconButton(
              onPressed: () {
                PageRouteTransition.push(context, EditItemUI());
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {},
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
                itemMap['leftStock'].toStringAsFixed(2) + ' ' + itemMap['unit'],
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
                automaticIndicatorColorAdjustment: true,
                indicatorWeight: 2,
                indicatorColor: Colors.indigo,
                tabs: [
                  Tab(
                    child: Text(
                      "Timeline",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Details",
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
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Change',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Final Stock',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700),
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
                    .collection('stockTransaction')
                    .where('itemId', isEqualTo: itemMap['id'])
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
                    return Text("No Data");
                  }
                  return LinearProgressIndicator();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container TimelineCard({required var stkTxnMap}) {
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(stkTxnMap['date'].toString()),
              ],
            ),
          ),
          Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Text(stkTxnMap['change'] + ' ' + stkTxnMap['unit'])),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(stkTxnMap['finalStock'].toStringAsFixed(2) +
                  ' ' +
                  stkTxnMap['unit']),
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
                      itemMap['lowStock'].toStringAsFixed(2) +
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
                      itemMap['leftStock'].toStringAsFixed(2) +
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
              Spacer()
            ],
          ),
        ],
      ),
    );
  }

  AlertDialog AddStockAlertBox() {
    return AlertDialog(
      title: Text('Add Stock for ' + itemMap['name']),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _addStockQuantity,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '0.0',
                      labelText: 'Stock Qunatity',
                      prefixText: '+',
                      suffixText: itemMap['unit']),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This is required";
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
            if (_formKey.currentState!.validate()) {
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
                    double.parse(_addStockQuantity.text).toStringAsFixed(2),
                'finalStock':
                    itemMap['leftStock'] + double.parse(_addStockQuantity.text),
                'date': uniqueId
              };

              itemMap['leftStock'] = stkTxnMap['finalStock'];
              await FirebaseFirestore.instance
                  .collection('stockTransaction')
                  .doc(uniqueId.toString())
                  .set(stkTxnMap)
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('items')
                    .doc(itemMap['id'].toString())
                    .update({'leftStock': stkTxnMap['finalStock']});
                _addStockQuantity.clear();
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _reduceStockQuantity,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '0.0',
                      labelText: 'Stock Qunatity',
                      prefixText: '-',
                      suffixText: itemMap['unit']),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This is required";
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
            if (_formKey.currentState!.validate()) {
              showLoading(context);
              int uniqueId = DateTime.now().millisecondsSinceEpoch;
              Map<String, dynamic> stkTxnMap = {
                'id': uniqueId,
                'activity': "Reduce Stock",
                'itemName': itemMap['name'],
                'itemCategory': itemMap['category'],
                'itemId': itemMap['id'],
                'unit': itemMap['unit'],
                'change': '- ' +
                    double.parse(_reduceStockQuantity.text).toStringAsFixed(2),
                'finalStock': itemMap['leftStock'] -
                    double.parse(_reduceStockQuantity.text),
                'date': uniqueId
              };

              itemMap['leftStock'] = stkTxnMap['finalStock'];
              await FirebaseFirestore.instance
                  .collection('stockTransaction')
                  .doc(uniqueId.toString())
                  .set(stkTxnMap)
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('items')
                    .doc(itemMap['id'].toString())
                    .update({'leftStock': stkTxnMap['finalStock']});
                _reduceStockQuantity.clear();
                PageRouteTransition.pop(context);
                PageRouteTransition.pop(context);
              });
            }
          },
        ),
      ],
    );
  }
}
