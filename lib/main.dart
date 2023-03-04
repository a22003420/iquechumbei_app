import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'lista.dart';
import 'registo.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    Dashboard(),
    Lista(),
    Registo(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Lista de avaliações',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Registo de avaliação',
            ),
          ],
        ),
      ),
    );
  }
}
