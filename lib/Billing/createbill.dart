import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Billing/additemcart.dart';
import 'package:page_transition/page_transition.dart';

class CreateBillUi extends StatefulWidget {
  const CreateBillUi({Key? key}) : super(key: key);

  @override
  State<CreateBillUi> createState() => _CreateBillUiState();
}

class _CreateBillUiState extends State<CreateBillUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text(
          "Create Bill/Invoice",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          invoiceDateField(),
          partyNameField(),
          itemsList(),
          totalAmountField(),
        ],
      ),
    );
  }

  Widget invoiceDateField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Invoice #3"),
              Text("20 Sep 2022"),
            ],
          ),
          Text("Edit")
        ],
      ),
    );
  }

  Widget partyNameField() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                hintText: 'Enter Party Name',
                label: Text("Party Name"),
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                prefix: Text("+91"),
                border: OutlineInputBorder(),
                hintText: 'Enter Mobile Number',
                label: Text("Mobile Number"),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget itemsList() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ITEMS"),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: AddItemCartUi(),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: double.infinity,
              color: Colors.grey,
              child: Center(child: Text("Add Items")),
            ),
          ),
        ],
      ),
    );
  }

  Widget totalAmountField() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(flex: 3, child: Text("Total Amount")),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "₹",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
