import 'package:aula10crud/task_model.dart';
import 'package:sqflite/sqflite.dart'; // Importando o pacote sqflite para trabalhar com banco de dados SQLite
import 'package:path/path.dart'; // Importando o pacote path para manipulação de caminhos de arquivos

class DatabaseHelper {
  // Definindo a classe DatabaseHelper
  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor(); // Instância única da classe
  static Database? _database; // Banco de dados

  DatabaseHelper._privateConstructor(); // Construtor privado

  Future<Database> get database async {
    // Método assíncrono para obter o banco de dados
    if (_database != null)
      return _database!; // Retorna o banco de dados se já estiver inicializado

    _database = await _initDatabase(); // Inicializa o banco de dados
    return _database!; // Retorna o banco de dados inicializado
  }

  Future<Database> _initDatabase() async {
    // Método assíncrono privado para inicializar o banco de dados
    final path =
        await getDatabasesPath(); // Obtém o caminho do diretório de bancos de dados
    return openDatabase(
      // Abre o banco de dados
      join(path, 'tarefa.db'), // Caminho do banco de dados
      onCreate: (db, version) {
        // Callback executado quando o banco de dados é criado
        return db.execute(
          // Executa uma operação SQL
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)', // Cria a tabela 'tasks'
        );
      },
      version: 1, // Versão do banco de dados
    );
  }

  Future<int> insertTarefa(Tarefa tarefa) async {
    // Método assíncrono para inserir uma tarefa no banco de dados
    final db = await database; // Obtém o banco de dados
    return await db.insert(
        'tasks', tarefa.toMap()); // Insere a tarefa na tabela 'tasks'
  }

  Future<List<Tarefa>> fetchTarefa() async {
    // Método assíncrono para buscar todas as tarefas do banco de dados
    final db = await database; // Obtém o banco de dados
    final List<Map<String, dynamic>> maps =
        await db.query('tarefa'); // Consulta todas as tarefas
    return List.generate(maps.length, (i) {
      // Gera uma lista de tarefas a partir dos resultados da consulta
      return Tarefa.fromMap(maps[i]); // Converte o mapa em um objeto Task
    });
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    // Método assíncrono para atualizar uma tarefa no banco de dados
    final db = await database; // Obtém o banco de dados
    return await db
        .update('tarefa', tarefa.toMap(), // Atualiza a tarefa na tabela 'tasks'
            where: 'id = ?',
            whereArgs: [tarefa.id]); // Condição para atualização
  }

  Future<int> deleteTarefa(int id) async {
    // Método assíncrono para deletar uma tarefa do banco de dados
    final db = await database; // Obtém o banco de dados
    return await db.delete('tarefa',
        where: 'id = ?', whereArgs: [id]); // Deleta a tarefa da tabela 'tasks'
  }
}
