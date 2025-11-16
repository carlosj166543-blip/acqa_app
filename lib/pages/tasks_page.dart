// lib/pages/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';

class TasksPage extends StatelessWidget {
  static const routeName = '/tasks';
  const TasksPage({Key? key}) : super(key: key);

  Future<void> _showAddDialog(BuildContext context, DateTime date) async {
    final _ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar tarefa'),
        content: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Título da tarefa')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final text = _ctrl.text.trim();
              if (text.isEmpty) return;
              final id = DateTime.now().microsecondsSinceEpoch.toString();
              final task = Task(id: id, title: text, date: date, completed: false);
              Provider.of<TaskController>(context, listen: false).addTask(task);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = ModalRoute.of(context)!.settings.arguments as DateTime;
    final tasks = context.watch<TaskController>().tasksForDay(date);
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas — ${DateFormat.yMMMd().format(date)}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: tasks.isEmpty
            ? Center(child: Text('Sem tarefas para este dia'))
            : ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => TaskItem(task: tasks[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, date),
        child: const Icon(Icons.add),
      ),
    );
  }
}
