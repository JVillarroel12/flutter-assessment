import 'package:flutter/material.dart';
import 'package:flutter_assessment/database/database.dart';
import 'package:flutter_assessment/screens/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDataBase.instance;
  runApp(MainApp(database: database));
}

class MainApp extends StatelessWidget {
  final AppDataBase database;
  const MainApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight App',
      home: MainMenuScreen(database: database),
    );
  }
}
