import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Home/homeUI.dart';
import 'package:jeweller_stockbook/Home/itemsUI.dart';
import 'package:jeweller_stockbook/Home/MoreUI.dart';
import 'package:jeweller_stockbook/Mortage/MortgageUI.dart';
import 'package:jeweller_stockbook/utils/animated_indexed_stack.dart';
import 'package:jeweller_stockbook/utils/components.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({Key? key}) : super(key: key);

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  int _currentIndex = 0;
  DateTime? currentBackPressTime;
  bool canPop = false;

  final _screens = [
    HomeUI(),
    ItemsUI(),
    MortgageUI(),
    MoreUI(),
  ];

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
        // body: Body(),
        body: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              fillColor: Theme.of(context).colorScheme.surface,
              child: child,
            );
          },
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: BottomNavNew(),
      ),
    );
  }

  Widget Body() {
    return AnimatedIndexedStack(
      index: _currentIndex,
      children: [
        HomeUI(),
        ItemsUI(),
        MortgageUI(),
        MoreUI(),
      ],
    );
  }

  Widget BottomNavNew() {
    return NavigationBar(
      backgroundColor: Colors.white,
      onDestinationSelected: (value) {
        setState(() => _currentIndex = value);
      },
      selectedIndex: _currentIndex,
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
