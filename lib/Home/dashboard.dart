import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Billing/additemcart.dart';
import 'package:jeweller_billbook/Stock/lowStock.dart';
import 'package:page_route_transition/page_route_transition.dart';

class DashboardUi extends StatefulWidget {
  const DashboardUi({Key? key}) : super(key: key);

  @override
  State<DashboardUi> createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  String uname = "Not";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.book),
            Text('StockBook'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            statusBlocks(),
            ItemTimeline(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton.extended(
            onPressed: () {},
            elevation: 2,
            heroTag: 'btn1',
            icon: Icon(Icons.receipt),
            label: Text('Mortage Billing'),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              PageRouteTransition.push(context, AddItemCartUi());
            },
            elevation: 2,
            icon: Icon(Icons.print),
            label: Text('Invoice'),
          ),
        ],
      ),
    );
  }

  Widget statusBlocks() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              StatsCard(
                onPress: () {},
                icon: Icons.file_download_outlined,
                cardColor: Color.fromARGB(255, 217, 241, 218),
                label: 'Mortage',
                amount: '₹ ' + '0',
              ),
              SizedBox(
                width: 10,
              ),
              StatsCard(
                onPress: () {},
                icon: Icons.file_upload_outlined,
                cardColor: Color.fromARGB(255, 255, 223, 227),
                label: 'Sales',
                amount: '₹ ' + '0',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              StatsCard(
                onPress: () {
                  PageRouteTransition.push(context, LowStockUI());
                },
                icon: null,
                cardColor: Colors.grey.shade200,
                label: 'Value of Items',
                amount: 'Low Stocks',
              ),
              SizedBox(
                width: 10,
              ),
              StatsCard(
                onPress: () {},
                icon: Icons.bar_chart,
                cardColor: Colors.grey.shade300,
                label: 'Weekly Sale',
                amount: '₹ ' + '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget StatsCard({final onPress, label, icon, amount, cardColor}) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(label),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        icon,
                        size: 18,
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ItemTimeline() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Timeline",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
              TimelineCard(),
              TimelineCard(),
              TimelineCard(),
            ],
          ),
        ],
      ),
    );
  }

  Container TimelineCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mangtika',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('date'),
              ],
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.center, child: Text('+ 1 Gms')),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text('50 gms'),
            ),
          ),
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
}
