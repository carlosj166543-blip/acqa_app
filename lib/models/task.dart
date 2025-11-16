// lib/models/task.dart
import 'dart:convert';

class Task {
  String id;
  String title;
  DateTime date;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.completed = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'completed': completed,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        completed: map['completed'] as bool,
      );

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
