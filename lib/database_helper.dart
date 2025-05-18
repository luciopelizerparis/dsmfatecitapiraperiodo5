// Importa o pacote sqflite, que fornece acesso a banco de dados SQLite em Flutter.
import 'package:sqflite/sqflite.dart';
// Importa funções utilitárias para manipular caminhos de arquivos.
import 'package:path/path.dart';

/// Classe auxiliar (singleton) para gerenciamento do banco de dados local.
class DatabaseHelper {
  // Instância única (singleton) da classe DatabaseHelper.
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Armazena a instância do banco de dados.
  static Database? _database;

  // Construtor privado.
  DatabaseHelper._init();

  /// Getter que retorna a instância do banco de dados, inicializando se necessário.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  /// Inicializa o banco de dados com o nome fornecido.
  Future<Database> _initDB(String filePath) async {
    // Obtém o caminho padrão onde os bancos de dados são armazenados no dispositivo.
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath); // Junta o caminho com o nome do arquivo.

    // Carrega ou cria o banco de dados com a função de criação (_createDB) se necessário.
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Cria a estrutura inicial do banco de dados.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

     // Aqui serão implementadas também as demais tabelas:
    // await db.execute(''' CREATE TABLE itens ...'''');
  }

  /// Insere um novo usuário na tabela `users`.
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    await db.insert('users', user);
  }

  /// Busca um usuário no banco pelo email e senha (para login).
  Future<Map<String, dynamic>?> getUsuario(String email, String password) async {
    final db = await instance.database;

    // Consulta na tabela `users` onde email e password combinam.
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    // Se encontrou algum resultado, retorna o primeiro registro.
    if (result.isNotEmpty) {
      return result.first;
    }

    // Caso contrário, retorna null.
    return null;
  }
}
