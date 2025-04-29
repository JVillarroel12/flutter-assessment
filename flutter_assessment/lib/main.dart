import 'package:flutter/material.dart';
import 'package:flutter_assessment/api/flight_api.dart';
import 'package:flutter_assessment/database/dao/itinerary_dao.dart';
import 'package:flutter_assessment/database/dao/leg_dao.dart';
import 'package:flutter_assessment/database/database.dart';
import 'package:flutter_assessment/screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase.instance;
  final itineraryDao = ItineraryDao(database);
  final legDao = LegDao(database);

  final flightApi = FlightApi();
  final itineraries = await flightApi.fetchItineraries();
  final legs = await flightApi.fetchLegs();
  final legsMap = {for (var leg in legs) leg.id: leg};

  for (final leg in legs) {
    await legDao.insertLeg(leg);
  }

  for (final itinerary in itineraries) {
    await itineraryDao.insertItineraryWithLegs(itinerary, itinerary.legs);
  }
  runApp(MainApp(database: database));
}

class MainApp extends StatelessWidget {
  final AppDatabase database;
  const MainApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight App',
      home: MainMenuScreen(database: database),
    );
  }
}
