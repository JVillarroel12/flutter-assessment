import 'package:flutter/material.dart';
import 'package:flutter_assessment/api/models/itinerary.dart';
import 'package:flutter_assessment/api/models/leg.dart';
import 'package:flutter_assessment/core/app_colors.dart';
import 'package:flutter_assessment/database/dao/leg_dao.dart';
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
    return Scaffold(
      appBar: toolbar(),
      backgroundColor: AppColors.background,

      body: FutureBuilder<List<Leg>>(
        future: LegDao(database).getLegsByIds(itinerary.legs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No se encontraron tramos"));
          }
          final legs = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),

                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.principalCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumen del Itinerario',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          SizedBox(height: 12),
                          _buildDetailRow('Agente', itinerary.agent),
                          _buildDetailRow('Precio', itinerary.price),
                          if (itinerary.agentRating != null)
                            _buildDetailRow(
                              'Raiting',
                              '${itinerary.agentRating!.toStringAsFixed(1)}/10',
                            ),
                          _buildDetailRow('Numero de tramos', '${legs.length}'),
                        ],
                      ),
                    ),
                  ),
                ),
                ...legs.map((leg) => __buildLegCard(leg)),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar toolbar() => AppBar(
    title: Text("Detalle de Itinerario ${itinerary.id}"),
    backgroundColor: AppColors.appBar,
    foregroundColor: Colors.white,
  );

  Padding _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "${label}:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Card __buildLegCard(Leg leg) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tramo ${leg.id}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            _buildLegDetail(
              'Aerolinea:',
              '${leg.airlineName} (${leg.airlineId})',
            ),
            _buildLegDetail(
              'Ruta:',
              '${leg.departureAirport} → ${leg.arrivalAirport}',
            ),
            _buildLegDetail('Salida:', _formatDateTime(leg.departureTime)),
            _buildLegDetail('Llegada:', _formatDateTime(leg.arrivalTime)),
            _buildLegDetail('Duración:', '${leg.durationMins} minutos'),
            _buildLegDetail('Escalas:', '${leg.stops}'),
          ],
        ),
      ),
    );
  }

  Padding _buildLegDetail(String label, String value) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
