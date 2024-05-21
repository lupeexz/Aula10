import 'package:flutter/material.dart';
// Importando o pacote material, que contém os widgets do Flutter
import 'package:aula10crud/DatabaseHelper.dart';
// Importando o arquivo database_helper.dart para gerenciar o banco de dados
import 'package:aula10crud/task_model.dart';
// Importando o arquivo task_model.dart que define o modelo de tarefa

void main() =>
    runApp(MyApp()); // Função principal que inicializa o aplicativo Flutter

class MyApp extends StatelessWidget {
  // Classe MyApp que herda de StatelessWidget
  @override
  Widget build(BuildContext context) {
    // Método build que retorna o widget principal do aplicativo
    return MaterialApp(
      // MaterialApp: Widget que define as configurações gerais do aplicativo
      title: 'CRUD with SQLite', // Título do aplicativo
      theme: ThemeData(
        // Tema do aplicativo
        primarySwatch: Colors.green, // Cor primária do tema
      ),
      home: TaskListScreen(), // Tela inicial do aplicativo
    );
  }
}

class TaskListScreen extends StatefulWidget {
  // Classe TaskListScreen que herda de StatefulWidget
  @override
  _TaskListScreenState createState() =>
      _TaskListScreenState(); // Cria uma instância do estado para TaskListScreen
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Classe privada que gerencia o estado da tela TaskListScreen
  final dbHelper =
      DatabaseHelper.instance; // Instância do helper do banco de dados
  final TextEditingController titleController =
      TextEditingController(); // Controlador para o campo de título
  final TextEditingController descriptionController =
      TextEditingController(); // Controlador para o campo de descrição

  @override
  Widget build(BuildContext context) {
    // Método build que retorna o widget da tela TaskListScreen
    return Scaffold(
      // Scaffold: Widget responsável por criar um layout "padrão" para a tela
      appBar: AppBar(
        // AppBar: Barra localizada na parte superior da tela
        title: Text('Aprendendo um CRUD com SQLite'), // Título da AppBar
      ),
      body: FutureBuilder<List<Tarefa>>(
        // FutureBuilder: Widget que constrói um widget baseado em um Future
        future: dbHelper
            .fetchTarefa(), // Future que busca as tarefas do banco de dados
        builder: (context, snapshot) {
          // Construtor do widget baseado no Future
          if (!snapshot.hasData) {
            // Verifica se os dados ainda não foram carregados
            return Center(
                child:
                    CircularProgressIndicator()); // Mostra um indicador de progresso
          }

          return ListView.builder(
            /* ListView.builder: Widget que constrói uma lista de itens de 
            acordo com os dados*/
            itemCount: snapshot.data!.length, // Número total de itens na lista
            itemBuilder: (context, index) {
              // Construtor de itens da lista
              return ListTile(
                // ListTile: Widget que define um item de lista
                title: Text(snapshot.data![index].titulo), // Título do item
                subtitle:
                    Text(snapshot.data![index].descricao), // Descrição do item
                trailing: IconButton(
                  // Botão de ação à direita do item
                  icon: Icon(Icons.delete), // Ícone do botão
                  onPressed: () {
                    // Ação ao pressionar o botão
                    dbHelper.deleteTarefa(snapshot.data![index]
                        .id!); // Deleta a tarefa selecionada do banco de dados
                    setState(() {}); // Atualiza a interface
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // FloatingActionButton: Botão flutuante na parte inferior da tela
        child: Icon(Icons.add), // Ícone do botão
        onPressed: () => _showTaskDialog(), // Ação ao pressionar o botão
      ),
    );
  }

  _showTaskDialog() async {
    // Método assíncrono para mostrar o diálogo de adição de tarefa
    await showDialog(
      // showDialog: Função que exibe um diálogo
      context: context, // Contexto do aplicativo
      builder: (context) => AlertDialog(
        // AlertDialog: Diálogo de alerta
        title: Text('Nova Tarefa'), // Título do diálogo
        content: Column(
          // Conteúdo do diálogo
          mainAxisSize: MainAxisSize.min, // Tamanho mínimo do conteúdo
          children: [
            TextField(
              // Campo de texto para o título da tarefa
              controller: titleController, // Controlador do campo de texto
              decoration: InputDecoration(
                  labelText: 'Título'), // Decoração do campo de texto
            ),
            TextField(
              // Campo de texto para a descrição da tarefa
              controller:
                  descriptionController, // Controlador do campo de texto
              decoration: InputDecoration(
                  labelText: 'Descrição'), // Decoração do campo de texto
            ),
          ],
        ),
        actions: [
          // Ações do diálogo
          TextButton(
            // Botão de cancelar
            child: Text('Cancelar'), // Texto do botão
            onPressed: () =>
                Navigator.pop(context), // Ação ao pressionar o botão
          ),
          TextButton(
            // Botão de salvar
            child: Text('Salvar'), // Texto do botão
            onPressed: () {
              // Ação ao pressionar o botão
              final tarefa = Tarefa(
                // Cria uma nova tarefa com os dados inseridos
                titulo: titleController.text, // Título da tarefa
                descricao: descriptionController.text, // Descrição da tarefa
              );
              dbHelper.insertTarefa(
                  tarefa); // Insere a nova tarefa no banco de dados
              setState(() {}); // Atualiza a interface
              Navigator.pop(context); // Fecha o diálogo
            },
          ),
        ],
      ),
    );
  }
}
