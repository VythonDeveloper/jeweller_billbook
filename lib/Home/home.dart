import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Home/dashboard.dart';
import 'package:jeweller_billbook/Home/items.dart';
import 'package:jeweller_billbook/Home/more.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedbottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      body: Body(),
      bottomNavigationBar: BottomNavNew(),
    );
  }

  Widget Body() {
    return IndexedStack(
      index: _selectedbottomNavIndex,
      children: [
        DashboardUi(),
        ItemsUi(),
        MoreUI(),
      ],
    );
  }

  Widget BottomNavNew() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedbottomNavIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey.withOpacity(0.5),
      ),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
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
          label: 'More',
          icon: Icon(Icons.apps),
        ),
      ],
    );
  }
}
