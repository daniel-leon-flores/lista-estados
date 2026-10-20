import 'package:flutter/material.dart';

import 'pantalla_pedidos.dart';
import 'repositorio_falso.dart';

// IA: punto de entrada generado con Claude (Anthropic). Se crea un solo
// repositorio para toda la app: así cuenta bien las llamadas (la primera
// falla y la segunda, desde Reintentar, funciona).
void main() {
  runApp(AppCafeteria(repositorio: RepositorioFalso()));
}

// IA: MaterialApp con Material 3 que muestra la pantalla de pedidos.
class AppCafeteria extends StatelessWidget {
  const AppCafeteria({super.key, required this.repositorio});

  final RepositorioFalso repositorio;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista con tres estados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: PantallaPedidos(repositorio: repositorio),
    );
  }
}
