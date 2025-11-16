// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/task_controller.dart';
import 'pages/login_page.dart';
import 'pages/calendar_page.dart';
import 'pages/tasks_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ACQAApp());
}

class ACQAApp extends StatelessWidget {
  const ACQAApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ACQA Tarefas',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (_) => const LoginPage(),
          CalendarPage.routeName: (_) => const CalendarPage(),
          TasksPage.routeName: (_) => const TasksPage(),
        },
      ),
    );
  }
}

