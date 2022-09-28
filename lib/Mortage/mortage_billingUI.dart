import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Services/user.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';
import 'package:page_route_transition/page_route_transition.dart';

class MortageBillingUI extends StatefulWidget {
  const MortageBillingUI({super.key});

  @override
  State<MortageBillingUI> createState() => _MortageBillingUIState();
}

class _MortageBillingUIState extends State<MortageBillingUI> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemWeightController = TextEditingController();
  final _principleAmountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _dateController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _transactionType = "MortgageTransaction";
  String _expiryDate = '';
  static const _interest = 0.02;
  double _returnAmount = 0.0;
  int uniqueId = DateTime.now().millisecondsSinceEpoch;

  String _selectedWeight = Constants.unitList[0];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = Constants.dateFormat(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
            .millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    super.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _itemDescriptionController.dispose();
    _itemWeightController.dispose();
    _principleAmountController.dispose();
    _tenureController.dispose();
    _dateController.dispose();
  }

  _calculateMortage() {
    int tenure =
        _tenureController.text.isEmpty ? 0 : int.parse(_tenureController.text);
    double PA = _principleAmountController.text.isEmpty
        ? 0
        : double.parse(_principleAmountController.text);
    _returnAmount = PA + (PA * (_interest * tenure));
    _expiryDate = Constants.dateFormat(DateTime(
            selectedDate.year, selectedDate.month + tenure, selectedDate.day)
        .millisecondsSinceEpoch);
    setState(() {});

    var last7thday = Constants.dateFormat(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 84)
        .millisecondsSinceEpoch);
    print(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 84)
        .millisecondsSinceEpoch);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 6, 29),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = Constants.dateFormat(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
                .millisecondsSinceEpoch);
      });
    _calculateMortage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mortage Billing'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            CustomTextFieldThis(
              readOnly: false,
              controller: _customerNameController,
              label: 'Customer Name',
              obsecureText: false,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This is required';
                }
                return null;
              },
            ),
            CustomTextFieldThis(
              readOnly: false,
              controller: _customerPhoneController,
              label: 'Customer Phone',
              obsecureText: false,
              prefixText: '+91 ',
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This is required';
                }
                if (value.length != 10) {
                  return 'Phone number must be of length 10';
                }
                return null;
              },
            ),
            CustomTextFieldThis(
              readOnly: false,
              controller: _itemDescriptionController,
              label: 'Item Description (optional)',
              obsecureText: false,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                return null;
              },
            ),
            CustomTextFieldThis(
              onTap: () {
                _selectDate(context);
              },
              readOnly: true,
              controller: _dateController,
              label: 'Date',
              obsecureText: false,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                return null;
              },
            ),
            Row(
              children: [
                Flexible(
                  child: CustomTextFieldThis(
                    readOnly: false,
                    controller: _itemWeightController,
                    label: 'Weight',
                    obsecureText: false,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is required';
                      }
                      if (double.parse(value) < 0.0) {
                        return 'Keep Positive';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedWeight,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 17,
                    ),
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    underline: Container(),
                    style: TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        _selectedWeight = value!;
                      });
                    },
                    items: Constants.unitList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: CustomTextFieldThis(
                    readOnly: false,
                    controller: _principleAmountController,
                    label: 'Principle Amount',
                    obsecureText: false,
                    prefixText: '₹ ',
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) {
                      _calculateMortage();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is required';
                      }
                      if (int.parse(value) < 0) {
                        return 'Keep Positive';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: CustomTextFieldThis(
                    readOnly: false,
                    controller: _tenureController,
                    label: 'Tenure (in months)',
                    obsecureText: false,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _calculateMortage();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is required';
                      }
                      if (int.parse(value) < 0) {
                        return 'Keep Positive';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Divider(),
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
                      'Expiry Date',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _expiryDate,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Return Amount',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹ ' + _returnAmount.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFABButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showLoading(context);
            Map<String, dynamic> mortgageMap = {
              'id': uniqueId,
              'type': _transactionType,
              'name': _customerNameController.text,
              'mobile': "+91" + _customerPhoneController.text,
              'description': _itemDescriptionController.text,
              'date': _dateController.text,
              'weight': double.parse(_itemWeightController.text),
              'unit': _selectedWeight,
              'principalAmount': double.parse(_principleAmountController.text),
              'tenure': double.parse(_tenureController.text),
              'expiryDate': _expiryDate,
              'returnAmount': _returnAmount,
              'status': "Ongoing",
            };
            FirebaseFirestore.instance
                .collection('users')
                .doc(UserData.uid)
                .collection('transactions')
                .doc(uniqueId.toString())
                .set(mortgageMap)
                .then((value) {
              PageRouteTransition.pop(context);
              PageRouteTransition.pop(context);
            });
          }
        },
        icon: Icons.done,
        label: 'Save',
      ),
    );
  }

  Widget CustomTextFieldThis(
      {final label,
      onTap,
      obsecureText,
      textCapitalization,
      controller,
      keyboardType,
      prefixText,
      readOnly,
      onChanged,
      validator}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            onTap: onTap,
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              prefixText: prefixText,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
