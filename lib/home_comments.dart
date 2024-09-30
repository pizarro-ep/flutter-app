import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<dynamic> posts = []; // Lista para almacenar los posts
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    getPosts(); // Llamada a la función para obtener los datos al iniciar
  }

  Future<void> getPosts() async {
    String url = 'https://jsonplaceholder.typicode.com/posts';

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
          posts = data; // Actualiza la lista de posts
          isLoading = false; // Cambia el indicador de carga
        });
      } else {
        _showErrorDialog('Error en el servidor. Intenta de nuevo más tarde');
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  // Mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Mostrar el modal al hacer clic en un elemento de la lista
  void _showPostDetailModal(BuildContext context, dynamic post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Permite un modal más grande
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9, // Tamaño máximo del modal (90% de la pantalla)
          initialChildSize: 0.5, // Tamaño inicial del modal (50% de la pantalla)
          minChildSize: 0.3, // Tamaño mínimo del modal
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                controller: controller, // Permite que el contenido del modal sea scrollable
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      post['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(post['body']),
                    const SizedBox(height: 20),
                    // Aquí puedes agregar más widgets, como comentarios o botones
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el modal
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Inicio';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(
                    post['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post['body'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: const Icon(Icons.star),
                  onTap: () {
                    // Al hacer clic, se abre el modal con los detalles
                    _showPostDetailModal(context, post);
                  },
                );
              },
            ),
    );
  }
}
