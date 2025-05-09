import 'package:flutter/material.dart';
import 'tela_acesso.dart';

void main() {
  runApp(Pedidos());
}

class Pedidos extends StatelessWidget {
  const Pedidos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acesso Local',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaAcesso(),
    );
  }
}
