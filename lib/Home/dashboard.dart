import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Billing/createbill.dart';
import 'package:page_transition/page_transition.dart';

class DashboardUi extends StatefulWidget {
  const DashboardUi({Key? key}) : super(key: key);

  @override
  State<DashboardUi> createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dashboardTitleBar(),
        statusBlocks(),
        transactions(),
        dashboardFloatingButtons(),
      ],
    );
  }

  Widget dashboardTitleBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
          ),
          SizedBox(width: 15),
          Text(
            "Epson Printer",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget statusBlocks() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Card(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹ 0",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("To Collect"),
                            Icon(Icons.arrow_downward_sharp)
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_sharp),
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹ 0",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("To Pay"),
                            Icon(Icons.arrow_upward_sharp)
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_sharp),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Card(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stock Value",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Value of Items"),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_sharp),
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹ 0",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Weekly Sale (1 - 7)"),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_sharp),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget transactions() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: List.generate(
              2,
              (index) => transactionCard(
                  customerName: "Vivek",
                  invoiceNo: 1,
                  date: "18 Sept",
                  billAmt: 1543.0,
                  dueAmt: 0.0),
            ),
          )
        ],
      ),
    );
  }

  Widget transactionCard(
      {required String customerName,
      required int invoiceNo,
      required String date,
      required double billAmt,
      required double dueAmt}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customerName),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice #" + invoiceNo.toString(),
                    ),
                    Text(
                      date,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "₹ " + billAmt.toStringAsFixed(2),
                    ),
                    Text(
                      "Due ₹ " + dueAmt.toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dashboardFloatingButtons() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.black,
                child: Text(
                  'Mortgage Billing',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                onPressed: () {},
              ),
              MaterialButton(
                color: Colors.black,
                child: Text(
                  'Invoice/Billing',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: CreateBillUi(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
