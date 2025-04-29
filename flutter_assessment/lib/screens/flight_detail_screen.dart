import 'package:flutter/material.dart';
import 'package:flutter_assessment/api/models/itinerary.dart';
import 'package:flutter_assessment/database/database.dart';

class FlightDetailScreen extends StatelessWidget {
  final Itinerary itinerary;
  final AppDatabase database;

  const FlightDetailScreen({
    super.key,
    required this.itinerary,
    required this.database,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
