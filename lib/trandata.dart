import 'package:flutter/material.dart';

class DataTrans extends StatefulWidget {
  const DataTrans({super.key});

  @override
  State<DataTrans> createState() => _DataTransState();
}

class _DataTransState extends State<DataTrans> {
  String uid = "YD4UvVlgsjhcc0aiC29JVmHw7UC3";
  doTask() {
    num num1 = 12.369;
    print(num1.toDouble());
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
