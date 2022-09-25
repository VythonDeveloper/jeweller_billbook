import 'package:flutter/material.dart';
import 'package:jeweller_billbook/services/auth.dart';

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
      body: MaterialButton(
        onPressed: () {
          AuthMethods().signOut(context);
        },
        child: Text('Logout'),
      ),
    );
  }
}
