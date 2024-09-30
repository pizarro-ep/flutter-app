import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/widgets/bottom_navigation_bar.dart';
import 'dart:convert';

import 'package:myapp/widgets/utils.dart';

class Persons extends StatefulWidget {
  const Persons({super.key});

  @override
  PersonsState createState() => PersonsState();
}

class PersonsState extends State<Persons> {
  List<dynamic> users = []; // Lista para almacenar los user
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    getUsers();
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
      bottomNavigationBar: const BottomNavigation(currentPageIndex: 1),
    );
  }

  PreferredSizeWidget _builAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Personas"),
      automaticallyImplyLeading: false,
    );
  }

  /// Método para obtener los usuarios
  Future<void> getUsers() async {
    String url = 'https://jsonplaceholder.typicode.com/users';

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
          users = data; // Actualiza la lista de posts
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
    // Texto del card
    List<Widget> buildCardText(user) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            user['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Text(
          user['username'],
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.start,
        ),
      ];
    }

    Widget buildCard(user) {
      return Card.filled(
        child: InkWell(
          onTap: () => {Navigator.pushNamed(context, '/person')},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación vertical de los elementos
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle, size: 50, color: Colors.blueGrey),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido del Column
                  children: [
                    ...buildCardText(user),
                    Row(
                      children: [
                        MyCustomButton(
                            label: "AGREGAR",
                            type: "primary",
                            onPressed: () => {_showDialogMessage("Agregar", "La persona ha sido agregado")}),
                        MyCustomButton(
                            label: "ELIMINAR",
                            type: "secondary",
                            onPressed: () => {_showDialogMessage("Agregar", "La persona ha sido eliminado")}),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true, // Esto asegura que el ListView se ajuste a su contenido
      physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll del ListView
      itemCount: users.length, padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final user = users[index];

        return Column(
          children: [
            buildCard(user),
          ],
        );
      },
    );
  }
}
