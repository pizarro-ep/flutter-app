import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda Página'),
      ),
      body: Center(
        child: Text(
          'Contenido de la segunda página',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
