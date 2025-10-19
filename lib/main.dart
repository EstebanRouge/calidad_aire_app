import 'package:flutter/material.dart';
import 'vistas/calidad_aire_vista.dart';

void main() {
  runApp(const CalidadAireApp());
}

class CalidadAireApp extends StatelessWidget {
  const CalidadAireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calidad del Aire Colombia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const CalidadAireVista(), //vista principal
    );
  }
}
