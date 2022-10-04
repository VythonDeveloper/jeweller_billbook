import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../Helper/user.dart';
import '../colors.dart';

class EditMortgageUi extends StatefulWidget {
  final mrtgMap;
  const EditMortgageUi({Key? key, required this.mrtgMap}) : super(key: key);

  @override
  State<EditMortgageUi> createState() => _EditMortgageUiState(mrtgMap: mrtgMap);
}

class _EditMortgageUiState extends State<EditMortgageUi> {
  final mrtgMap;
  _EditMortgageUiState({required this.mrtgMap});
  int uniqueId = DateTime.now().millisecondsSinceEpoch;
  final _formKey = GlobalKey<FormState>();
  // final _transactionType = "MortgageTransaction";
  final _shopName = new TextEditingController();
  final _customerName = new TextEditingController();
  final _mobile = new TextEditingController();
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
    _shopName.dispose();
    _customerName.dispose();
    _mobile.dispose();
    _description.dispose();
    _weight.dispose();
    _amount.dispose();
    _date.dispose();
    _interestPerMonth.dispose();
  }

  @override
  void initState() {
    super.initState();
    _shopName.text = mrtgMap['shopName'];
    _customerName.text = mrtgMap['customerName'];
    _mobile.text = mrtgMap['mobile'].split("+91")[1];
    _description.text = mrtgMap['description'];
    _weight.text = mrtgMap['weight'].toString();
    _selectedPurity = mrtgMap['purity'];
    _amount.text = mrtgMap['amount'].toString();
    _interestPerMonth.text = mrtgMap['interestPerMonth'].toString();
    _selectedMortgageStatus = mrtgMap['status'];
    selectedDate = DateTime.fromMillisecondsSinceEpoch(mrtgMap['date']);
    _date.text = Constants.dateFormat(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
            .millisecondsSinceEpoch);
    requestCalculation();
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
        title: Text(
          "Edit Mortgage",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            basicItemDetails(),
            SizedBox(
              height: 10,
            ),
            otherDetailsTabBar(),
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
            calculationsPart(),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFABButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showLoading(context);
            FocusScope.of(context).unfocus();

            Map<String, dynamic> updatedMortgageMap = {
              "shopName": _shopName.text,
              "customerName": _customerName.text,
              "mobile": "+91" + _mobile.text,
              "description": _description.text,
              "weight": double.parse(_weight.text),
              "purity": _selectedPurity,
              "amount": int.parse(_amount.text),
              "date": selectedDate.millisecondsSinceEpoch,
              "closingDate": 0,
              "interestPerMonth": double.parse(_interestPerMonth.text),
              "status": _selectedMortgageStatus
            };

            FirebaseFirestore.instance
                .collection('users')
                .doc(UserData.uid)
                .collection('mortgage')
                .doc(mrtgMap['id'].toString())
                .update(updatedMortgageMap)
                .then((value) {
              PageRouteTransition.pop(context);
              PageRouteTransition.pop(context);
            });
          }
        },
        icon: Icons.done,
        label: 'Update Changes',
      ),
    );
  }

  Widget basicItemDetails() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _shopName,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
              label: Text("Shop Name"),
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
            controller: _customerName,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
              label: Text("Customer Name"),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _mobile,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
              label: Text("Customer Mobile"),
              prefixText: '+91 ',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget otherDetailsTabBar() {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            child: TabBar(
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              unselectedLabelColor: Colors.grey,
              labelColor: primaryColor,
              indicatorColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: 'Item',
                ),
                Tab(
                  text: 'Interest',
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.17,
            child: TabBarView(
              children: [
                itemTabBar(),
                interestTabBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Purity",
                        style: TextStyle(fontSize: 12, color: Colors.indigo),
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
                        borderRadius: BorderRadius.circular(10),
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
        ],
      ),
    );
  }

  Widget interestTabBar() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
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
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
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
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(fontSize: 12, color: Colors.indigo),
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
                        borderRadius: BorderRadius.circular(10),
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
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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