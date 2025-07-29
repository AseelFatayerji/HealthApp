import 'package:flutter/material.dart';
import '../screens/pedomter_screen.dart';
import '../screens/calories_screen.dart';
import '../screens/info_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State {
  int _selectedIndex = 0;
  final List<Widget> widgetOptions = [
    const CaloriesScreen(),
    PedometerScreen(),
    const InfoScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department, size: 32),
              label: 'Calories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_walk_outlined, size: 32),
              label: 'Pedometer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline, size: 32),
              label: 'Info',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedIconTheme: IconThemeData(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          selectedItemColor: Color.fromARGB(255, 79, 199, 255),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
