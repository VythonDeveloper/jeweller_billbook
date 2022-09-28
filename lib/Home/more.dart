import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/services/auth.dart';

class MoreUI extends StatefulWidget {
  const MoreUI({super.key});

  @override
  State<MoreUI> createState() => _MoreUIState();
}

class _MoreUIState extends State<MoreUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          MaterialButton(
            onPressed: () {
              AuthMethods().signOut(context);
            },
            color: Color.fromARGB(255, 255, 239, 241),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(20),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 25, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
