// Importa os pacotes necessários para construir a interface e interagir com o banco de dados.
import 'package:flutter/material.dart';
import 'database_helper.dart'; // Arquivo que gerencia o banco de dados local/nativo, aplica o CRUD.
import 'tela_cardapio.dart';   // Tela que será exibida após o login.

/// Widget de estado para a tela de acesso (login/registro).
class TelaAcesso extends StatefulWidget {
  const TelaAcesso({super.key});

  @override
  State<TelaAcesso> createState() => _AccessScreenState();
}

/// Estado interno da tela de acesso.
class _AccessScreenState extends State<TelaAcesso> {
  bool estaLogado = true; // Indica se a tela está no modo login (true) ou registro (false).
  
  // Chave global usada para validar o formulário.
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar os dados digitados nos campos de texto.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmSenhaController = TextEditingController();

  // Instância do helper para acessar o banco de dados.
  final dbHelper = DatabaseHelper.instance;

  /// Alterna entre os modos de login e registro.
  void _toggleForm() {
    setState(() {
      estaLogado = !estaLogado;
    });
  }

  /// Valida e envia os dados do formulário.
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      if (estaLogado) {
        // Tenta encontrar o usuário no banco de dados com os dados fornecidos.
        final usuario = await dbHelper.getUsuario(email, senha);
        if (usuario != null) {
          // Se encontrou, navega para a tela do cardápio.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaCardapio()), // CORREÇÃO: "build" estava errado.
          );
        } else {
          // Caso contrário, mostra mensagem de erro.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário ou senha incorretos.')),
          );
        }
      } else {
        // Valida se as senhas coincidem no registro.
        if (_senhaController.text != _confirmSenhaController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('As senhas não coincidem.')),
          );
          return;
        }

        // Insere novo usuário no banco de dados.
        await dbHelper.insertUser({
          'name': _nomeController.text.trim(),
          'email': email,
          'password': senha,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro realizado com sucesso!')),
        );

        // Volta para o modo login.
        _toggleForm();
      }
    }
  }

  /// Constrói a interface da tela de login/registro.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(estaLogado ? 'Login' : 'Registrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de nome (visível apenas no modo de registro).
              if (!estaLogado)
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                ),

              // Campo de email.
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Informe o email' : null,
              ),

              // Campo de senha.
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.length < 4 ? 'Senha muito curta' : null,
              ),

              // Campo de confirmação de senha ( visível apenas no modo de registro).
              if (!estaLogado)
                TextFormField(
                  controller: _confirmSenhaController,
                  decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: (value) => value!.length < 4 ? 'Senha muito curta' : null,
                ),

              const SizedBox(height: 20), // Espaçamento vertical.

              // Botão de envio do formulário.
              ElevatedButton(
                onPressed: _submit,
                child: Text(estaLogado ? 'Entrar' : 'Registrar'),
              ),

              // Botão de alternar entre login e registro.
              TextButton(
                onPressed: _toggleForm,
                child: Text(estaLogado ? 'Criar uma conta' : 'Já tem conta? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
