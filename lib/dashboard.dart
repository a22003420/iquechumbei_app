import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
          style: TextStyle(

            fontSize: 24.0, // tamanho da fonte em pontos
            fontWeight: FontWeight.bold, // negrito



          ),




        ),
        backgroundColor: Colors.blue,
      ),
    );

  }
}