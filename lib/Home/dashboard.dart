import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: 'Vivek')
        .get()
        .then((value) {
      print(value.docs[0].data());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StockBook'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            statusBlocks(),
            transactions(),
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
            onPressed: () {},
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
                label: 'To Collect',
                amount: '₹ ' + '0',
              ),
              SizedBox(
                width: 10,
              ),
              StatsCard(
                onPress: () {},
                icon: Icons.file_upload_outlined,
                cardColor: Color.fromARGB(255, 255, 223, 227),
                label: 'To Pay',
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
                onPress: () {},
                icon: null,
                cardColor: Colors.grey.shade200,
                label: 'Value of Items',
                amount: 'Stock Value',
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

  Widget transactions() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(uname),
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
}
