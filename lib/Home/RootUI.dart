import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/homeUI.dart';
import 'package:jeweller_stockbook/Home/itemsUI.dart';
import 'package:jeweller_stockbook/Home/settingsUI.dart';
import 'package:jeweller_stockbook/Home/MortgageUI.dart';
import 'package:jeweller_stockbook/utils/animated_indexed_stack.dart';
import 'package:jeweller_stockbook/utils/components.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({Key? key}) : super(key: key);

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  int _selectedbottomNavIndex = 0;
  DateTime? currentBackPressTime;
  bool canPop = false;

  onWillPop(val) {
    setState(() {
      canPop = true;
    });
    kSnackbar(context, 'Press back again to exit!');
    Future.delayed(
      Duration(seconds: 2),
      () {
        setState(() {
          canPop = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: onWillPop,
      child: Scaffold(
        body: Body(),
        bottomNavigationBar: BottomNavNew(),
      ),
    );
  }

  Widget Body() {
    return AnimatedIndexedStack(
      index: _selectedbottomNavIndex,
      children: [
        HomeUI(),
        ItemsUI(),
        MortgageUI(),
        SettingsUI(),
      ],
    );
  }

  Widget BottomNavNew() {
    return NavigationBar(
      backgroundColor: Colors.white,
      onDestinationSelected: (value) {
        setState(() => _selectedbottomNavIndex = value);
      },
      selectedIndex: _selectedbottomNavIndex,
      destinations: [
        NavigationDestination(icon: Icon(Icons.bar_chart), label: "Sales"),
        NavigationDestination(icon: Icon(Icons.inventory_2), label: "Items"),
        NavigationDestination(
            icon: Icon(Icons.receipt_long), label: "Mortgage"),
        NavigationDestination(icon: Icon(Icons.apps), label: "More"),
      ],
    );
  }
}
