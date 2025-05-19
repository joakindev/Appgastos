import 'package:flutter/material.dart';
import 'pantallas/pantalla_principal.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Gastos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PantallaPrincipal(),
    );
  }
}