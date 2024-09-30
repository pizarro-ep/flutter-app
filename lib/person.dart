import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/widgets/utils.dart';

class Person extends StatefulWidget {
  final int idUser;
  const Person({super.key, required this.idUser});

  @override
  PersonState createState() => PersonState();
}

class PersonState extends State<Person> {
  Map<String, dynamic> user = {}; // Lista para almacenar los user
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    getUser(widget.idUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _builAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildPersonsCards(),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _builAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Personas"),
    );
  }

  /// Método para obtener los usuarios
  Future<void> getUser(idUser) async {
    String url = 'https://jsonplaceholder.typicode.com/users/$idUser';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = data; // Actualiza la lista de posts
          isLoading = false; // Cambia el indicador de carga
        });
      }
    } catch (e) {
      _showDialogMessage("Error", "$e");
    }
  }

  /// Dialog para mostrar mensajes
  void _showDialogMessage(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyCustomDialog(
          title: title,
          content: content,
          buttonText: 'Aceptar',
        );
      },
    );
  }

  ///
  /// CREAR WIDGETS
  ///

  // Crer card
  // Crear card de personas
  Widget _buildPersonsCards() {
    Widget buildStackProfile() {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 50,
            width: 100,
            height: 100,
            child: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(color: Colors.blueGrey),
            ),
          )
        ],
      );
    }

    return buildStackProfile();
  }
}
