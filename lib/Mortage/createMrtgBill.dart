import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';

import '../Helper/user.dart';
import '../utils/colors.dart';

class CreateMrtgBillUi extends StatefulWidget {
  final customerName;
  final phone;
  final mrtgBookId;
  const CreateMrtgBillUi(
      {Key? key,
      required this.customerName,
      required this.phone,
      required this.mrtgBookId})
      : super(key: key);

  @override
  State<CreateMrtgBillUi> createState() => _CreateMrtgBillUiState(
      customerName: customerName, phone: phone, mrtgBookId: mrtgBookId);
}

class _CreateMrtgBillUiState extends State<CreateMrtgBillUi> {
  final customerName;
  final phone;
  final mrtgBookId;
  _CreateMrtgBillUiState({this.customerName, this.phone, this.mrtgBookId});

  int uniqueId = DateTime.now().millisecondsSinceEpoch;
  final _formKey = GlobalKey<FormState>();
  final _description = new TextEditingController();
  final _weight = new TextEditingController();

  Map<String, dynamic> _purityMap = {
    "purityList": ['14K', '18K', '22K'],
    "14K": 14 / 24,
    "18K": 18 / 24,
    "22K": 22 / 24
  };
  String _selectedPurity = "18K";

  final _amount = new TextEditingController();
  final _date = new TextEditingController();
  final _interestPerMonth = new TextEditingController();
  List<String> _mortgageStatus = ['Active', 'Closed'];
  String _selectedMortgageStatus = 'Active';

  DateTime selectedDate = DateTime.now();

  Map<String, dynamic> _calculatedResult = {
    "daysSince": 0,
    "interestAmount": 0.0,
    "totalDue": 0.0,
    "valuation": 0.0,
    "profitLoss": 'NA'
  };

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
    _weight.dispose();
    _amount.dispose();
    _date.dispose();
    _interestPerMonth.dispose();
  }

  @override
  void initState() {
    super.initState();
    _date.text = Constants.dateFormat(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
            .millisecondsSinceEpoch);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 6, 29),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.text = Constants.dateFormat(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
                .millisecondsSinceEpoch);
      });
    requestCalculation();
  }

  void requestCalculation() {
    double weightValue =
        _weight.text.isEmpty ? 0.0 : double.parse(_weight.text);
    int amountValue = _amount.text.isEmpty ? 0 : int.parse(_amount.text);
    double interestPerMonth = _interestPerMonth.text.isEmpty
        ? 0.0
        : double.parse(_interestPerMonth.text);

    _calculatedResult = Constants.calculateMortgage(
        weightValue,
        _selectedPurity,
        amountValue,
        interestPerMonth,
        selectedDate.millisecondsSinceEpoch);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Mortgage Bill"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            customerDetails(),
            SizedBox(
              height: 10,
            ),
            billForm(),
            calculationsPart(),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFABButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showLoading(context);
            Map<String, dynamic> mrtgBillMap = {
              "id": uniqueId,
              "bookId": mrtgBookId,
              "description": _description.text,
              "weight": double.parse(_weight.text),
              "unit": "GMS",
              "purity": _selectedPurity,
              "amount": int.parse(_amount.text),
              "totalPaid": 0,
              "date": selectedDate.millisecondsSinceEpoch,
              "lastPaymentDate": selectedDate.millisecondsSinceEpoch,
              "closingDate": 0,
              "interestPerMonth": double.parse(_interestPerMonth.text),
              "status": _selectedMortgageStatus
            };

            FirebaseFirestore.instance
                .collection('users')
                .doc(UserData.uid)
                .collection('mortgageBill')
                .doc(uniqueId.toString())
                .set(mrtgBillMap)
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserData.uid)
                  .collection('mortgageBook')
                  .doc(mrtgBookId.toString())
                  .update({
                'totalPrinciple': FieldValue.increment(int.parse(_amount.text))
              });
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }
        },
        icon: Icons.done,
        label: 'Save',
      ),
    );
  }

  Widget customerDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Text(customerName[0]),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                phone,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget billForm() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            controller: _description,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
              label: Text("Item Description"),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This is required";
              }
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weight,
                  decoration: InputDecoration(
                    hintText: '0.0',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixText: "GMS",
                    label: Text("Weight"),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,3}')),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    requestCalculation();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _weight.text = '0.0';
                      return 'This is required';
                    }
                    if (double.parse(value) <= 0.0) {
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Purity",
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        isDense: true,
                        value: _selectedPurity,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 17,
                        ),
                        elevation: 2,
                        borderRadius: BorderRadius.circular(5),
                        underline: Container(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            _selectedPurity = value!;
                          });
                          requestCalculation();
                        },
                        items: _purityMap['purityList']
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _amount,
                  decoration: InputDecoration(
                    hintText: '0',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    prefixText: "₹ ",
                    label: Text("Amount"),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,0}')),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    requestCalculation();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _amount.text = '0';
                      return 'This is required';
                    }
                    if (int.parse(value) <= 0) {
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
                  controller: _interestPerMonth,
                  decoration: InputDecoration(
                    hintText: '0.0',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixText: "%",
                    label: Text("Interest/month"),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}')),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    requestCalculation();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _interestPerMonth.text = '0.0';
                      return 'This is required';
                    }
                    if (double.parse(value) < 0.0) {
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
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                  controller: _date,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    label: Text("As of Date"),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        isDense: true,
                        value: _selectedMortgageStatus,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 17,
                        ),
                        elevation: 2,
                        borderRadius: BorderRadius.circular(5),
                        underline: Container(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            _selectedMortgageStatus = value!;
                          });
                        },
                        items: _mortgageStatus
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget calculationsPart() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
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
}
