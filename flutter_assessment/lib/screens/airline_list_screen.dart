import 'package:flutter/material.dart';
import 'package:flutter_assessment/database/database.dart';

class AirlineListScreen extends StatefulWidget {
  final AppDataBase database;
  const AirlineListScreen({super.key, required this.database});

  @override
  State<AirlineListScreen> createState() => _AirlineListScreenState();
}

class _AirlineListScreenState extends State<AirlineListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
