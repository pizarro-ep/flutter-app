import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comments extends StatefulWidget {
  final int postId; // Recibimos el id del post

  const Comments({super.key, required this.postId});

  @override
  CommentsState createState() => CommentsState();
}

class CommentsState extends State<Comments> {
  List<dynamic> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getComments(widget.postId); // Llamada a la API con el id del post
  }

  // Obtener los detalles del post con el id proporcionado
  Future<void> getComments(int postId) async {
    String url = 'https://jsonplaceholder.typicode.com/posts/$postId/comments';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          comments = jsonDecode(response.body); // Almacenamos los detalles del post
          isLoading = false; // Terminamos de cargar
        });
      } else {
        _showErrorDialog('Error al cargar los detalles');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.person_rounded, size: 16), // Icono que deseas agregar
                            const SizedBox(width: 8), // Espacio entre el icono y el texto
                            Text(
                              comment['email'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            comment['body'],
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ));
                  }),
            ),
    );
  }
}
