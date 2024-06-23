import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/homeUI.dart';
import 'package:jeweller_stockbook/Home/itemsUI.dart';
import 'package:jeweller_stockbook/Home/settingsUI.dart';
import 'package:jeweller_stockbook/Home/mrtgBook.dart';
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

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showSnackBar(context, 'Press back again to exit!');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
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
        MortgageUi(),
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
