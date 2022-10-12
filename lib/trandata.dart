import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        .collection('transactions')
        .get()
        .then((value) async {
      if (value.size > 0) {
        for (int i = 0; i < value.size; i++) {
          String txnId = value.docs[i]['id'].toString();

          // await FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(uid)
          //     .collection('transactions')
          //     .doc(txnId)
          //     .update({'remark': ''});
        }
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
