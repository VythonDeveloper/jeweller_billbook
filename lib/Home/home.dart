import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jeweller_billbook/Home/dashboard.dart';
import 'package:jeweller_billbook/Home/items.dart';
import 'package:jeweller_billbook/Home/more.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List _pageList = [DashboardUi(), ItemsUi()];
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
      backgroundColor: Color.fromARGB(255, 226, 242, 255),
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedbottomNavIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
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
          icon: SvgPicture.asset(
            './lib/assets/icons/items.svg',
            color: _selectedbottomNavIndex == 1
                ? Color.fromARGB(255, 0, 55, 100)
                : Colors.grey,
            height: 20,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Stock Entry',
          icon: SvgPicture.asset(
            './lib/assets/icons/more.svg',
            color: _selectedbottomNavIndex == 2
                ? Color.fromARGB(255, 0, 55, 100)
                : Colors.grey,
            height: 20,
          ),
        ),
      ],
    );
  }
}
