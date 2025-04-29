import 'package:flutter/material.dart';
import 'package:flutter_assessment/components/airline_card.dart';
import 'package:flutter_assessment/core/app_colors.dart';
import 'package:flutter_assessment/database/dao/leg_dao.dart';
import 'package:flutter_assessment/database/database.dart';

class AirlineListScreen extends StatefulWidget {
  final AppDatabase database;
  const AirlineListScreen({super.key, required this.database});

  @override
  State<AirlineListScreen> createState() => _AirlineListScreenState();
}

class _AirlineListScreenState extends State<AirlineListScreen> {
  late LegDao legDao;
  List<Map<String, dynamic>> airlines = [];
  List<Map<String, dynamic>> filteredAirlines = [];
  String? filterName;

  @override
  void initState() {
    super.initState();
    legDao = LegDao(widget.database);
    _loadAirlines();
  }

  Future<void> _loadAirlines() async {
    final airlinesData = await legDao.getAllAirlinesWithLegCount();
    setState(() {
      airlines = airlinesData;
      filteredAirlines = airlinesData;
    });
  }

  void _filterAirlines(String? name) {
    setState(() {
      filterName = name;
      if (name == null || name.isEmpty) {
        filteredAirlines = airlines;
      } else {
        filteredAirlines =
            airlines
                .where(
                  (airline) => airline['airline_name'].toLowerCase().contains(
                    name.toLowerCase(),
                  ),
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
                labelText: 'Filtrar por nombre',
                hintText: 'Ej: conviasa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterAirlines,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAirlines.length,
              itemBuilder: (context, index) {
                final airline = filteredAirlines[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CardAirline(airline: airline),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar toolbar() => AppBar(
    title: Text("Lista de Aerolineas"),
    backgroundColor: AppColors.appBar,
    foregroundColor: Colors.white,
  );
}
