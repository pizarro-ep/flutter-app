import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/widgets/bottom_navigation_bar.dart';
import 'package:myapp/widgets/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<dynamic> posts = []; // Lista para almacenar los posts
  List<dynamic> users = []; // Lista para almacenar los user
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    getPosts(); // Llamada a la función para obtener los datos al iniciar
    getUsers();
  }

  // Widget principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildCarousel(), // Construyes el carruseles
                  _buildPostContent(), // Construyes el contenido de los posts
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavigation(currentPageIndex: 0),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Inicio"),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Perfil',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abrir perfil')));
          },
        ),
      ],
    );
  }

  /// Obtener los posts
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
        _showDialogMessage("Error", "Error en el servidor. Intenta de nuevo más tarde");
      }
    } catch (error) {
      MyCustomDialog(title: "Error", content: error.toString());
    }
  }

  /// Obtener usuario
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
      } else {
        _showDialogMessage("Error", 'Error en el servidor. Intenta de nuevo más tarde');
      }
    } catch (error) {
      _showDialogMessage("Error", error.toString());
    }
  }

  /// Obtener los comentarios
  Future<List<dynamic>> getComments(postId) async {
    String url = 'https://jsonplaceholder.typicode.com/posts/$postId/comments';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en el servidor. Intenta de nuevo más tarde');
      }
    } catch (error) {
      throw Exception('Error en el servidor. Intenta de nuevo más tarde');
    }
  }

  // Crear carrousel
  Widget _buildCarousel() {
    List<int> sliders = [1, 2, 3, 4, 5];

    return CarouselSlider(
      options: CarouselOptions(height: 200, aspectRatio: 16 / 9),
      items: sliders.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: const BoxDecoration(color: Color.fromARGB(255, 163, 161, 155)),
              child: _buildImages("images/System.jpg"),
            );
          },
        );
      }).toList(),
    );
  }

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

  // Mostrar el modal al hacer clic en un elemento de la lista
  void _showModalPostComment(List<dynamic> comments) {
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
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Column(
                children: [
                  // Encabezado del modal que permanece fijo
                  _buildModalHeader(context),
                  const SizedBox(height: 16),
                  // Sección de contenido desplazable
                  _buildModalContent(controller, comments),
                ],
              ),
            );
          },
        );
      },
    );
  }

  ///
  /// CREAR WIDGETS
  ///

  /// Widget de imagen
  Widget _buildImages(image) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 200, // Define el ancho máximo
          minWidth: 150),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Crear el encabezado del modal
  Widget _buildModalHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Center(
          child: Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el modal
          },
          iconSize: 24,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  /// Crear el contenido del modal
  Widget _buildModalContent(controller, List<dynamic> comments) {
    return Expanded(
      child: ListView.builder(
        controller: controller,
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ListTile(
            title: Row(
              children: [
                const Icon(Icons.person_rounded, size: 16), // Icono que deseas agregar
                const SizedBox(width: 8), // Espacio entre el icono y el texto
                Expanded(
                  child: Text(
                    comment['email'],
                    overflow: TextOverflow.visible, // Permite que el texto haga wrap
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    softWrap: true, // Asegura que el texto haga wrap si es necesario
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(comment['body'], style: const TextStyle(fontSize: 10)),
            ),
          );
        },
      ),
    );
  }

  // Widget de los botones de opcion de cada post
  Widget _buildPostButtons(IconData icon, String label, void Function() handleEventClick) {
    return InkWell(
      onTap: handleEventClick, // Ejecuta la función al hacer clic
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

// Crear los botones de reaccion
  Widget _buildPostReaccionButtons(post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPostButtons(Icons.thumb_up, "Me gusta", () {
          _showDialogMessage("", "Me gusta");
        }),
        _buildPostButtons(Icons.comment, "Comentarios", () async {
          final comments = await getComments(post['id']);
          _showModalPostComment(comments);
        }),
        _buildPostButtons(Icons.share, "Compartir", () {
          _showDialogMessage("", "Compartir");
        }),
      ],
    );
  }

  // Crear contenido del post
  Widget _buildPostContent() {
    return ListView.builder(
      shrinkWrap: true, // Esto asegura que el ListView se ajuste a su contenido
      physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll del ListView
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final user = users.where((u) => u['id'] == post['userId']).toList();

        return Column(
          children: [
            ListTile(title: Text(user[0]['username']), leading: const Icon(Icons.person_outline_rounded)),
            ListTile(
              title: Text(post['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(post['body'], maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            _buildImages("images/picture.png"), // Imagen del post
            _buildPostReaccionButtons(post), // Construir botones de reacciones
            const Divider(), // Separador entre posts
          ],
        );
      },
    );
  }
}
