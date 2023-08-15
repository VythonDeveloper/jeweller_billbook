import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/homeUI.dart';
import 'package:jeweller_stockbook/Home/items.dart';
import 'package:jeweller_stockbook/Home/settingsUI.dart';
import 'package:jeweller_stockbook/Home/mrtgBook.dart';
import 'package:jeweller_stockbook/utils/animated_indexed_stack.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
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
        ItemsUi(),
        MortgageUi(),
        SettingsUI(),
      ],
    );
  }

  Widget BottomNavNew() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedbottomNavIndex,
      backgroundColor: primaryAccentColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey.withOpacity(0.5),
      ),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      selectedIconTheme: IconThemeData(size: 28),
      onTap: (value) {
        setState(() => _selectedbottomNavIndex = value);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Sales',
          icon: Icon(Icons.bar_chart),
        ),
        BottomNavigationBarItem(
          label: 'Items',
          icon: Icon(Icons.inventory_2),
        ),
        BottomNavigationBarItem(
          label: 'Mortgage',
          icon: Icon(Icons.receipt_long),
        ),
        BottomNavigationBarItem(
          label: 'More',
          icon: Icon(Icons.apps),
        ),
      ],
    );
  }
}
