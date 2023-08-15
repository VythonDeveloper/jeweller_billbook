import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Mortage/editMrtgBill.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';

import '../Helper/pdf_invoice_api.dart';
import '../Helper/user.dart';

class MrtgBillDetailsUi extends StatefulWidget {
  final mrtgBookId;
  final mrtgBillId;
  final customerName;
  final phone;

  const MrtgBillDetailsUi(
      {super.key,
      required this.mrtgBillId,
      required this.mrtgBookId,
      required this.customerName,
      required this.phone});

  @override
  State<MrtgBillDetailsUi> createState() => _MrtgBillDetailsUiState(
      mrtgBookId: mrtgBookId,
      mrtgBillId: mrtgBillId,
      customerName: customerName,
      phone: phone);
}

class _MrtgBillDetailsUiState extends State<MrtgBillDetailsUi> {
  final mrtgBookId;
  final mrtgBillId;
  final customerName;
  final phone;
  _MrtgBillDetailsUiState(
      {this.mrtgBookId, this.mrtgBillId, this.customerName, this.phone});
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

  Map<String, dynamic> mrtgBillMap = {
    "id": 0,
    "bookId": 0,
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
    fetchMrtgBillDetails();
  }

  Future<void> fetchMrtgBillDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('mortgageBill')
        .doc(mrtgBillId.toString())
        .get()
        .then((value) {
      mrtgBillMap = value.data()!;

      _calculatedResult = Constants.calculateMortgage(
          mrtgBillMap['weight'],
          mrtgBillMap['purity'],
          mrtgBillMap['amount'],
          mrtgBillMap['interestPerMonth'],
          mrtgBillMap['lastPaymentDate']);
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
              onPressed: () {},
              icon: Icon(Icons.call),
            ),
            IconButton(
              onPressed: () async {
                final pdfFile = await PdfInvoiceApi.generate(
                    action: "Share", dataMap: {'': ''});
                PdfInvoiceApi.shareFile(pdfFile);
              },
              icon: Icon(
                Icons.ios_share,
                color: profitColor,
              ),
            ),
            IconButton(
              onPressed: () {
                navPush(
                        context,
                        EditMrtgBillUi(
                            customerName: customerName,
                            phone: phone,
                            mrtgBillMap: mrtgBillMap))
                    .then((value) {
                  fetchMrtgBillDetails();
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
                    return deleteMrtgBillAlert();
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
          backgroundColor: primaryColor,
          extendedIconLabelSpacing: 10,
          icon: Icon(
            Icons.add,
            color: primaryAccentColor,
          ),
          label: Text(
            'Payment',
            style: TextStyle(
              color: primaryAccentColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.5,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final pdfFile = await PdfInvoiceApi.generate(
                      action: "View", dataMap: {'': ''});
                  PdfInvoiceApi.openFile(pdfFile);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: primaryColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View Report',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: primaryAccentColor,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: primaryAccentColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Amount Paid',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                "₹ " + Constants.cFInt.format(mrtgBillMap['totalPaid']),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
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
          // SizedBox(
          //   height: 50,
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 8.0),
          //     child: AppBar(
          //       backgroundColor: primaryAccentColor,
          //       bottom: TabBar(
          //         splashBorderRadius: BorderRadius.circular(40),
          //         labelColor: primaryColor,
          //         unselectedLabelColor: Colors.grey,
          //         automaticIndicatorColorAdjustment: true,
          //         indicatorWeight: 2,
          //         labelStyle: TextStyle(
          //           fontWeight: FontWeight.w600,
          //           letterSpacing: 0.5,
          //           fontSize: 15,
          //           fontFamily: 'San',
          //         ),
          //         indicatorSize: TabBarIndicatorSize.label,
          //         indicatorColor: primaryColor,
          //         tabs: [
          //           Tab(text: "Details"),
          //           Tab(text: "Payment Timeline"),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: primaryAccentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              splashBorderRadius: BorderRadius.circular(40),
              labelColor: primaryColor,
              unselectedLabelColor: Colors.blueGrey.shade200,
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
              indicatorColor: primaryColor,
              tabs: [
                Tab(text: "Details"),
                Tab(text: "Payment Timeline"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                details(),
                paymentTimeline(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget details() {
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
                mrtgBillMap['description'],
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
                      mrtgBillMap['weight'].toStringAsFixed(3) +
                          " " +
                          mrtgBillMap['unit'],
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
                      mrtgBillMap['purity'],
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
                      "₹ " + Constants.cFInt.format(mrtgBillMap['amount']),
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
                      Constants.dateFormat(mrtgBillMap['date']),
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
                      Constants.cFDecimal
                              .format(mrtgBillMap['interestPerMonth']) +
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
                      mrtgBillMap['status'],
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

  Widget paymentTimeline() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
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
                          'Total Paid',
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
                          '#',
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
                    .where('mrtgBillId', isEqualTo: mrtgBillId)
                    .where('type', isEqualTo: _transactionType)
                    .orderBy('date', descending: true)
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var mrtgTxnMap = snapshot.data.docs[index];

                          return paymentRow(mrtgTxnMap: mrtgTxnMap);
                        },
                      );
                    }
                    return PlaceholderText(
                      text1: "No Payment",
                      text2: "CAPTURED",
                    );
                  }
                  return CustomLoading();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container paymentRow({required var mrtgTxnMap}) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              Constants.dateTimeFormat(mrtgTxnMap['date']),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '₹ ' + Constants.cFInt.format(mrtgTxnMap['paidAmount']),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return deleteBillPaymentAlert(
                          txnId: mrtgTxnMap['id'],
                          paidAmount: mrtgTxnMap['paidAmount']);
                    },
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog deleteMrtgBillAlert() {
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
                .collection('mortgageBill')
                .doc(mrtgBillMap['id'].toString())
                .delete()
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('mortgageBook')
                  .doc(mrtgBillMap['bookId'].toString())
                  .update({
                'totalPrinciple': FieldValue.increment(
                  -int.parse(mrtgBillMap['amount'].toString()),
                ),
                'totalPaid': FieldValue.increment(
                  -int.parse(mrtgBillMap['totalPaid'].toString()),
                )
              });
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('transactions')
                  .where('type', isEqualTo: _transactionType)
                  .where('mrtgBillId', isEqualTo: mrtgBillMap['id'])
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

  AlertDialog deleteBillPaymentAlert(
      {required int txnId, required int paidAmount}) {
    return AlertDialog(
      title: Text('Delete transaction and all transactions?'),
      content: SingleChildScrollView(
        child: Text("Deleting transaction will effect Total Paid!"),
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
                .collection('transactions')
                .doc(txnId.toString())
                .delete()
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('mortgageBook')
                  .doc(mrtgBookId.toString())
                  .update({"totalPaid": FieldValue.increment(-paidAmount)});

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('mortgageBill')
                  .doc(mrtgBillId.toString())
                  .update({"totalPaid": FieldValue.increment(-paidAmount)});
              mrtgBillMap['totalPaid'] -= paidAmount;

              Navigator.pop(context);
              Navigator.pop(context);
            });
            setState(() {});
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
                      'Add Payment for Mortgage Bill',
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

                      Map<String, dynamic> billPaymentMap = {
                        'id': uniqueId,
                        'date': selectedMrtgTxnDate.millisecondsSinceEpoch,
                        'description': customerName + " paid due",
                        'mrtgBillId': mrtgBillId,
                        'paidAmount': int.parse(_paidAmount.text),
                        'type': _transactionType
                      };
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(UserData.uid)
                          .collection('transactions')
                          .doc(uniqueId.toString())
                          .set(billPaymentMap)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserData.uid)
                            .collection('mortgageBook')
                            .doc(mrtgBookId.toString())
                            .update({
                          "totalPaid":
                              FieldValue.increment(int.parse(_paidAmount.text))
                        });

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserData.uid)
                            .collection('mortgageBill')
                            .doc(mrtgBillId.toString())
                            .update({
                          "totalPaid":
                              FieldValue.increment(int.parse(_paidAmount.text))
                        });
                        mrtgBillMap['totalPaid'] += int.parse(_paidAmount.text);
                        _paidAmount.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                      color: primaryColor,
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
