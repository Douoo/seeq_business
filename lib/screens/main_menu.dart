import 'package:flutter/material.dart';
import 'package:seeq_business/screens/profile_settings.dart';

import '../utils/constants.dart';
import 'events.dart';
import 'home_dashboard.dart';
import 'messages.dart';

class MainMenu extends StatefulWidget {
  static const String route = '/options';
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentNavIndex = 0;
  final tabs = [
    Events(),
    Messages(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isHomePage = _currentNavIndex != 0 ? true : false;
        if (isHomePage) {
          setState(() => _currentNavIndex = 0);
        }
        return !isHomePage;
      },
      child: Scaffold(
        body: tabs[_currentNavIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: kSecondaryColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
          currentIndex: _currentNavIndex,
          onTap: (int index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
        ),
      ),
    );
  }
}
