import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        // Botón del menú en la AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
                Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(87, 173, 244, 1),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pageview),
              title: const Text('Segunda Página'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.pushNamed(context, '/second');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tercera Página'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.pushNamed(context, '/third');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Diseño'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.pushNamed(context, '/design');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Contenido de la página de inicio',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
