import 'package:flutter/material.dart';

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
  static const _interest = 0.02;
  double returnAmount = 0.0;

  String _selectedWeight = 'GMS';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _dateController.text = selectedDate.day.toString() +
        '-' +
        selectedDate.month.toString() +
        '-' +
        selectedDate.year.toString();
  }

  //--------------------------->

  _calculateMortage() {
    _tenureController.text =
        _tenureController.text.toString().replaceAll('-', '');
    _principleAmountController.text =
        _principleAmountController.text.toString().replaceAll('-', '');
    int PA = int.parse(_principleAmountController.text);
    returnAmount = PA + (PA * (_interest * int.parse(_tenureController.text)));
    setState(() {});
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
        _dateController.text = selectedDate.day.toString() +
            '-' +
            selectedDate.month.toString() +
            '-' +
            selectedDate.year.toString();
      });
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
                    items: ['GMS', 'KGS', 'TON']
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
                      _dateController.text,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      '₹ $returnAmount',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
