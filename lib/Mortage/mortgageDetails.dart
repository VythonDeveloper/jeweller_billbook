import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Mortage/editmortgage.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../Helper/user.dart';

class MortgageDetailsUi extends StatefulWidget {
  final mrtgId;
  const MortgageDetailsUi({super.key, required this.mrtgId});

  @override
  State<MortgageDetailsUi> createState() =>
      _MortgageDetailsUiState(mrtgId: mrtgId);
}

class _MortgageDetailsUiState extends State<MortgageDetailsUi> {
  final mrtgId;
  _MortgageDetailsUiState({this.mrtgId});
  final _formKey = GlobalKey<FormState>();
  final _paidAmount = new TextEditingController();
  final _mrtgTxnDate = new TextEditingController();
  final _transactionType = "MortgageTransaction";
  DateTime selectedMrtgTxnDate = DateTime.now();
  int totalPaid = 0;

  @override
  void dispose() {
    super.dispose();
    _paidAmount.dispose();
    _mrtgTxnDate.dispose();
  }

  Map<String, dynamic> mrtgMap = {
    "id": 0,
    "customerName": '',
    "mobile": '',
    "description": '',
    "weight": 0.0,
    "unit": '',
    "purity": '',
    "amount": 0,
    "totalPaid": 0,
    "date": 0,
    "closingDate": 0,
    "interestPerMonth": 0.0,
    "status": ''
  };

  Map<String, dynamic> _calculatedResult = {
    "daysSince": 0,
    "interestAmount": 0.0,
    "totalDue": 0.0,
    "valuation": 0.0,
    "profitLoss": 'NA'
  };

  @override
  void initState() {
    super.initState();
    _mrtgTxnDate.text = Constants.dateFormat(DateTime(selectedMrtgTxnDate.year,
            selectedMrtgTxnDate.month, selectedMrtgTxnDate.day)
        .millisecondsSinceEpoch);
    fetchMortgageDetails();
  }

  Future<void> fetchMortgageDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('mortgage')
        .doc(mrtgId.toString())
        .get()
        .then((value) {
      mrtgMap = value.data()!;

      _calculatedResult = Constants.calculateMortgage(
          mrtgMap['weight'],
          mrtgMap['purity'],
          mrtgMap['amount'],
          mrtgMap['interestPerMonth'],
          mrtgMap['lastPaymentDate']);
      setState(() {});
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedMrtgTxnDate,
        firstDate: DateTime(2000, 6, 29),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (picked != null && picked != selectedMrtgTxnDate)
      setState(() {
        selectedMrtgTxnDate = picked;
        _mrtgTxnDate.text = Constants.dateFormat(DateTime(
                selectedMrtgTxnDate.year,
                selectedMrtgTxnDate.month,
                selectedMrtgTxnDate.day)
            .millisecondsSinceEpoch);
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
                PageRouteTransition.push(
                        context, EditMortgageUi(mrtgMap: mrtgMap))
                    .then((value) {
                  fetchMortgageDetails();
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
                    return DeleteMortgageAlert();
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
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'btn3',
          extendedPadding: EdgeInsets.symmetric(horizontal: 50),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return addMrtgPaymentModal();
              },
            );
          },
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.indigo,
          extendedIconLabelSpacing: 10,
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: Text(
            'Payment',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
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
                mrtgMap['customerName'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                mrtgMap['mobile'],
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
                'Amount Paid',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              Text(
                "₹ " + Constants.cFInt.format(mrtgMap['totalPaid']),
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
                        'Date',
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
                          'Paid',
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
                          'Total Paid',
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
                    .where('mortgageId', isEqualTo: mrtgMap['id'])
                    .where('type', isEqualTo: _transactionType)
                    .orderBy('date', descending: true)
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length > 0) {
                      totalPaid = 0;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var mrtgTxnMap = snapshot.data.docs[index];
                          totalPaid +=
                              int.parse(mrtgTxnMap['paidAmount'].toString());

                          return TimelineCard(
                              mrtgTxnMap: mrtgTxnMap, totalPaid: totalPaid);
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

  Container TimelineCard({required var mrtgTxnMap, required int totalPaid}) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              Constants.dateFormat(mrtgTxnMap['date']),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '₹ ' + Constants.cFInt.format(mrtgTxnMap['paidAmount']),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '₹ ' + Constants.cFInt.format(totalPaid),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item Description',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              Text(
                mrtgMap['description'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      mrtgMap['weight'].toStringAsFixed(3) +
                          " " +
                          mrtgMap['unit'],
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
                      'Purity',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      mrtgMap['purity'],
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
                      'Amount',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "₹ " + Constants.cFInt.format(mrtgMap['amount']),
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
                      'Opening Date',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      Constants.dateFormat(mrtgMap['date']),
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
                      'Interest/month',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      Constants.cFDecimal.format(mrtgMap['interestPerMonth']) +
                          "%",
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
                      'Status',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      mrtgMap['status'],
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
          Visibility(
            visible: _calculatedResult['profitLoss'] != 'NA',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yor\'re in'),
                Text(
                  _calculatedResult['profitLoss'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _calculatedResult['profitLoss'] == 'Profit'
                        ? profitColor
                        : lossColor,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Text(
            "Calculations",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Days Since",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    Constants.cFInt.format(_calculatedResult['daysSince']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Interest Amount",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "₹ " +
                        Constants.cFDecimal
                            .format(_calculatedResult['interestAmount']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Due",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "₹ " +
                        Constants.cFDecimal
                            .format(_calculatedResult['totalDue']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Valuation",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "₹ " +
                        Constants.cFDecimal
                            .format(_calculatedResult['valuation']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  AlertDialog DeleteMortgageAlert() {
    return AlertDialog(
      title: Text('Delete mortgage and all transactions?'),
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
                .collection('mortgage')
                .doc(mrtgMap['id'].toString())
                .delete()
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('transactions')
                  .where('type', isEqualTo: _transactionType)
                  .where('mortgageId', isEqualTo: mrtgMap['id'])
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

  Widget addMrtgPaymentModal() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: Color.fromARGB(255, 255, 255, 255),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Paid Amount for Mortgage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _paidAmount,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(),
                          hintText: '0',
                          prefixText: "₹ ",
                          labelText: 'Amount',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This is required";
                          }
                          if (int.parse(value) <= 0) {
                            return "Keep positive";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextFormField(
                        onTap: () {
                          _selectDate(context);
                        },
                        readOnly: true,
                        controller: _mrtgTxnDate,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          label: Text("As of Date"),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate()) {
                      showLoading(context);
                      int uniqueId = DateTime.now().millisecondsSinceEpoch;

                      Map<String, dynamic> mrtgTxnMap = {
                        'id': uniqueId,
                        'date': selectedMrtgTxnDate.millisecondsSinceEpoch,
                        'description': mrtgMap['customerName'] + " paid due",
                        'mortgageId': mrtgId,
                        'paidAmount': int.parse(_paidAmount.text),
                        'type': _transactionType
                      };
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(UserData.uid)
                          .collection('transactions')
                          .doc(uniqueId.toString())
                          .set(mrtgTxnMap)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserData.uid)
                            .collection('mortgage')
                            .doc(mrtgMap['id'].toString())
                            .update({
                          "totalPaid":
                              FieldValue.increment(int.parse(_paidAmount.text))
                        });
                        mrtgMap['totalPaid'] += int.parse(_paidAmount.text);
                        _paidAmount.clear();
                        PageRouteTransition.pop(context);
                        PageRouteTransition.pop(context);
                      });
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Create",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    });
  }
}
