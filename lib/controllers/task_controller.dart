// lib/controllers/task_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

String dateKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

class TaskController extends ChangeNotifier {
  final List<Task> _tasks = [];
  static const _prefsKey = 'acqa_tasks_v1';

  List<Task> get allTasks => List.unmodifiable(_tasks);

  TaskController() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) return;
    final List decoded = json.decode(jsonString);
    _tasks.clear();
    _tasks.addAll(decoded.map((e) => Task.fromMap(Map<String, dynamic>.from(e))));
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void addTask(Task task) {
    _tasks.add(task);
    _sortAll();
    saveTasks();
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    saveTasks();
    notifyListeners();
  }

  void toggleCompleted(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _tasks[i].completed = !_tasks[i].completed;
    _sortAll();
    saveTasks();
    notifyListeners();
  }

  /// Retorna lista filtrada para a data e já ordenada conforme regra:
  /// pendentes primeiro, depois concluídas; em cada grupo ordem alfabética (A→Z).
  List<Task> tasksForDay(DateTime date) {
    final key = dateKey(date);
    final tasks = _tasks.where((t) => dateKey(t.date) == key).toList();
    tasks.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return tasks;
  }

  void _sortAll() {
    _tasks.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
  }
}
