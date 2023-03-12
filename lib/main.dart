import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'lista.dart';
import 'registo.dart';

bool _isFirstRun = true; //flag

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_isFirstRun == true) {
    // testa se é a primeira vez que a app é executado
    final preferences = await SharedPreferences.getInstance(); //memória

       preferences.setStringList("IHM", [
         "mini-teste",
         "2023/02/02 18:30",
         "3",
         "Estudar para o mini-teste"
       ]);

    preferences.setStringList("Computação Móvel", [
      "defesa",
      "2023/03/03 18:30",
      "4",
      "Rever o código para a defesa"
    ]);

    preferences.setStringList("LP2", [
      "frequencia",
      "2023/05/10 12:30",
      "4",
      "Estudar para a frequencia, ver material de apoio"
    ]);

    preferences.setStringList("Cyber", [
      "frequencia",
      "2023/03/18 18:30",
      "4",
      "Estudar para a frequencia, ver material de apoio"
    ]);


    //preferences.clear(); //to clear all the data
    _isFirstRun = false;
    print("É a primeira vez que a app é corrida"); //flag
  } else {
    print("Não é a primeira vez que a app é corrida");
  }
  print(_isFirstRun);
  print(DateTime.now());
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  bool _isDarkMode = false; // adicionado para controlar o modo de luz/noturno
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
