import 'package:flutter/material.dart';
import 'package:flutter_assessment/api/models/itinerary.dart';
import 'package:flutter_assessment/components/flight_card.dart';
import 'package:flutter_assessment/core/app_colors.dart';
import 'package:flutter_assessment/database/dao/itinerary_dao.dart';
import 'package:flutter_assessment/database/database.dart';
import 'package:flutter_assessment/screens/flight_detail_screen.dart';

class FlightListScreen extends StatefulWidget {
  final AppDatabase database;
  const FlightListScreen({super.key, required this.database});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  late ItineraryDao itineraryDao;
  List<Itinerary> itineraries = [];
  List<Itinerary> filteredItineraries = [];
  String? filterAgent;
  @override
  void initState() {
    super.initState();
    itineraryDao = ItineraryDao(widget.database);
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    final loadedItineraries = await itineraryDao.getAllItinerariesWithLegs();
    setState(() {
      itineraries = loadedItineraries;
      filteredItineraries = loadedItineraries;
    });
  }

  void _filterItineraries(String? agent) {
    setState(() {
      filterAgent = agent;
      if (agent == null || agent.isEmpty) {
        filteredItineraries = itineraries;
      } else {
        filteredItineraries =
            itineraries
                .where(
                  (it) => it.agent.toLowerCase().contains(agent.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: toolbar(),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar por agente',
                hintText: 'Ej: Conviasa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterItineraries,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItineraries.length,
              itemBuilder: (context, index) {
                final itinerary = filteredItineraries[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FlightDetailScreen(
                                  itinerary: itinerary,
                                  database: widget.database,
                                ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: FlightCard(itinerary: itinerary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar toolbar() => AppBar(
    title: Text("Lista de Vuelos"),
    backgroundColor: AppColors.appBar,
    foregroundColor: Colors.white,
  );
}
