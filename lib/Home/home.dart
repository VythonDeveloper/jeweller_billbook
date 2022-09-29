import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/dashboard.dart';
import 'package:jeweller_stockbook/Home/items.dart';
import 'package:jeweller_stockbook/Home/more.dart';
import 'package:jeweller_stockbook/Mortage/mortgage.dart';
import 'package:jeweller_stockbook/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Color.fromARGB(255, 233, 233, 233),
        body: Body(),
        bottomNavigationBar: BottomNavNew(),
      ),
    );
  }

  Widget Body() {
    return IndexedStack(
      index: _selectedbottomNavIndex,
      children: [
        DashboardUi(),
        ItemsUi(),
        MortgageUi(),
        MoreUI(),
      ],
    );
  }

  Widget BottomNavNew() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedbottomNavIndex,
      selectedItemColor: Colors.indigo.shade900,
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
