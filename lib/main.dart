import 'package:flutter/material.dart';
import 'package:myapp/person.dart';
import 'package:myapp/persons.dart';
import 'package:myapp/register.dart';
import 'package:myapp/widgets/clipper.dart';
import 'login.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi primera App',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      onGenerateRoute: _onGenerateRoute,
      initialRoute: '/person',
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const InitApp());
      case '/login':
        return _createRoute(const Login());
      case '/register':
        return _createRoute(const Register());
      case '/home':
        return _createRoute(const Home());
      case '/persons':
        return _createRoute(const Persons());
      case '/person':
        return _createRoute(const Person(idUser: 1));
      default:
        return _createRoute(const InitApp());
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

// Pantalla principal de la app
class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ..._buildBg(context),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImages('images/mtc_2.png'),
                  const SizedBox(height: 16),
                  const Text(
                    "Bienvenido a MTC",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Crear el fondo de la pantalla
  List<Widget> _buildBg(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    const Color colorPrimary = Color.fromRGBO(30, 49, 51, 1);
    const Color colorSecondary = Color.fromRGBO(0, 1, 19, 1);

    return [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(width: width, height: height, color: colorPrimary),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: ClipPath(
          clipper:
              BuildClipper(initialPosition: Offset(width, 0), positions: [Offset(width, height), Offset(0, height)]),
          child: Container(width: width, height: height, color: colorSecondary),
        ),
      ),
    ];
  }

  // Widget de imagen
  Widget _buildImages(image) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200, // Define el ancho máximo
      ),
      child: Image.asset(image),
    );
  }
}
