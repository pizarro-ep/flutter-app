import 'package:flutter/material.dart';

/// Crear clipper personalizado para hacer container con n vertices
class BuildClipper extends CustomClipper<Path> {
  BuildClipper({required this.initialPosition, required this.positions});
  Offset initialPosition = const Offset(0, 0);
  final List<Offset> positions;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(initialPosition.dx, initialPosition.dy);
    for (int i = 0; i < positions.length; i++) {
      path.lineTo(positions[i].dx, positions[i].dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; // Si necesitas que siempre se recalculen los recortes
  }
}
