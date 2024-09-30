import 'package:flutter/material.dart';

// Este es un widget reutilizable para mostrar el diálogo
class MyCustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;

  const MyCustomDialog({super.key, required this.title, required this.content, this.buttonText = 'OK'});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text(buttonText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// Archivo separado de widgets
class MyCustomButton extends StatelessWidget {
  final String label;
  final String type;
  final VoidCallback onPressed;

  const MyCustomButton({
    super.key,
    required this.label,
    required this.type,
    required this.onPressed,
  });

  Map<String, Color> getColors() {
    Color bgColor;
    Color fgColor;
    switch (type) {
      case 'primary':
        bgColor = Colors.blue;
        fgColor = Colors.white;
        break;
      case 'secondary':
        bgColor = Colors.grey;
        fgColor = Colors.black;
        break;
      default:
        bgColor = Colors.blue;
        fgColor = Colors.white;
        break;
    }

    return {"bg": bgColor, "fg": fgColor};
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: getColors()["bg"],
              foregroundColor: getColors()["fg"],
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
