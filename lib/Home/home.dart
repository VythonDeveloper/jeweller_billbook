import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jeweller_billbook/Home/dashboard.dart';
import 'package:jeweller_billbook/Home/items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _pageList = [DashboardUi(), ItemsUi()];
  int _selectedbottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 233, 233, 233),
        body: SafeArea(
          child: _pageList[_selectedbottomNavIndex],
        ),
        bottomNavigationBar: bottomNavBar());
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              './lib/assets/icons/dashboard.svg',
              color: _selectedbottomNavIndex == 0
                  ? Color.fromARGB(255, 0, 55, 100)
                  : Colors.grey,
              height: 25,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              './lib/assets/icons/items.svg',
              color: _selectedbottomNavIndex == 1
                  ? Color.fromARGB(255, 0, 55, 100)
                  : Colors.grey,
              height: 25,
            ),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              './lib/assets/icons/more.svg',
              color: _selectedbottomNavIndex == 2
                  ? Color.fromARGB(255, 0, 55, 100)
                  : Colors.grey,
              height: 25,
            ),
            label: 'More',
          ),
        ],
        currentIndex: _selectedbottomNavIndex,
        selectedItemColor: Color.fromARGB(255, 0, 55, 100),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        onTap: (index) {
          setState(() {
            _selectedbottomNavIndex = index;
          });
        },
        elevation: 5);
  }

  Widget floatingButtons() {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Color.fromARGB(255, 74, 60, 112),
            label: Text("Mortgage Billing"),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Colors.deepPurpleAccent,
            label: Text("Invoice/Billing"),
          ),
        ),
      ],
    );
  }
}
