// lib/widgets/task_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaskController>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (_) => controller.toggleCompleted(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text('${task.date.toLocal().toIso8601String().split('T').first}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => controller.removeTask(task.id),
        ),
      ),
    );
  }
}
