import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screens/home_screen.dart';
import 'package:hospital/screens/messages_screen.dart';
import 'package:hospital/screens/schedule_screen.dart';
import 'package:hospital/screens/setting_screen.dart';

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    HomeScreen(),
    MessagesScreen(),
    ScheduleScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF7165D6),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.chat_bubble_text_fill,
                ),
                label: "Mensajes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: "Fichas"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Ajustes"),
          ],
        ),
      ),
    );
  }
}

