// Importa o pacote Flutter que fornece os widgets e funcionalidades básicas da interface.
import 'package:flutter/material.dart';

// Importa o arquivo 'tela_acesso.dart', que provavelmente contém a tela principal do app.
import 'tela_acesso.dart';

// Função principal que inicia a execução do aplicativo Flutter.
void main() {
  // Inicia o aplicativo chamando o widget Pedidos.
  runApp(Pedidos());
}

// Define um widget sem estado chamado Pedidos.
// Como StatelessWidget, ele não mantém estado interno que possa mudar durante a execução.
class Pedidos extends StatelessWidget {
  const Pedidos({super.key}); // Construtor com chave opcional (boa prática para identificação de widgets).

  @override
  Widget build(BuildContext context) {
    // O método build constrói a interface do app.
    return MaterialApp(
      title: 'Acesso Local', // Título do aplicativo (usado por navegadores e sistemas operacionais).
      theme: ThemeData(primarySwatch: Colors.blue), // Define o tema do app com cor primária azul.
      home: const TelaAcesso(), // Define a tela inicial do app como TelaAcesso (importada).
    );
  }
}
