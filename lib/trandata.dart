import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';

class DataTrans extends StatefulWidget {
  const DataTrans({super.key});

  @override
  State<DataTrans> createState() => _DataTransState();
}

class _DataTransState extends State<DataTrans> {
  String uid = "YD4UvVlgsjhcc0aiC29JVmHw7UC3";
  doTask() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('mortgageBill')
        .where('bookId', isEqualTo: 1665149120214)
        .get()
        .then((value) {
      if (value.size > 0) {
        int totalPrinciple = 0;
        for (int i = 0; i < value.size; i++) {
          int amount = value.docs[i]['amount'];
          totalPrinciple += amount;
        }
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('mortgageBook')
            .doc('1665149120214')
            .update({'totalPrinciple': totalPrinciple});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            doTask();
          },
          child: Text("Go do"),
        ),
      ),
    );
  }
}
