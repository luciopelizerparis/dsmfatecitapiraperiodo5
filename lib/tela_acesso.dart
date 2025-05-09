import 'package:flutter/material.dart';
import 'database_helper.dart';

class TelaAcesso extends StatefulWidget {
  const TelaAcesso({super.key});

  @override
  State<TelaAcesso> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<TelaAcesso> {
  bool estaLogado = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmSenhaController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  void _toggleForm() {
    setState(() {
      estaLogado = !estaLogado;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      if (estaLogado) {
        final usuario = await dbHelper.getUsuario(email, senha);
        if (usuario != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login bem sucedido!, ${usuario['name']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário ou senha incorretos.')),
          );
        }
      } else {
        if (_senhaController.text != _confirmSenhaController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('As senhas não coincidem.')),
          );
          return;
        }
        await dbHelper.insertUser({
          'name': _nomeController.text.trim(),
          'email': email,
          'password': senha,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro realizado com sucesso!')),
        );
        _toggleForm();
      }
    }
  }

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
              if (!estaLogado)
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Informe o email' : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.length < 4 ? 'Senha muito curta' : null,
              ),
              if (!estaLogado)
                TextFormField(
                  controller: _confirmSenhaController,
                  decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: (value) => value!.length < 4 ? 'Senha muito curta' : null,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(estaLogado ? 'Entrar' : 'Registrar'),
              ),
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
