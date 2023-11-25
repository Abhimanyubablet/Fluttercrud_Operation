import 'package:flutter/material.dart';
import 'package:profile_update_firebase/widgets/profile.dart';
import 'package:profile_update_firebase/widgets/setting.dart';

import 'firebase_work.dart';
import 'home.dart';

class DashBoard extends StatefulWidget{
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    MyHome(),
    MyProfile(),
    FirebaseWork(),
    MySetting(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      // Set the background color here
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // Update the selected index when a tab is pressed
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),backgroundColor: Colors.black,
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Profile',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Firebase work',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),

    );
  }
}