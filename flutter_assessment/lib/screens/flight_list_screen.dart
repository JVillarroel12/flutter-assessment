import 'package:flutter/material.dart';
import 'package:flutter_assessment/database/database.dart';

class FlightListScreen extends StatefulWidget {
  final AppDataBase database;
  const FlightListScreen({super.key, required this.database});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
