import 'package:flutter/material.dart';
import 'package:ai_study_app/app_palette.dart';

import 'ProfilePage.dart';
import 'StatsPage.dart';
import 'TaskScreen.dart';
import 'home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // pages will be constructed in build() so we can pass callbacks that
  // control _currentIndex from child widgets (e.g. HomeScreen).

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final pages = <Widget>[
      HomeScreen(
        onProfileTap: () {
          setState(() {
            _currentIndex = 3;
          });
        },
      ),
      const TaskScreen(),
      const StatsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [palette.bgTop, palette.bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(top: BorderSide(color: palette.border, width: 0.8)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: palette.primary,
            unselectedItemColor: palette.primarySoft,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined),
                activeIcon: Icon(Icons.task_alt),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart_rounded),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
