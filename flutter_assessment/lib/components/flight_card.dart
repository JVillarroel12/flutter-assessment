import 'package:flutter/material.dart';
import 'package:flutter_assessment/api/models/itinerary.dart';

class FlightCard extends StatelessWidget {
  final Itinerary itinerary;
  const FlightCard({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Itinerario ${itinerary.id}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Agente: ${itinerary.agent}', style: TextStyle(fontSize: 16)),
        Text('Precio: ${itinerary.price}', style: TextStyle(fontSize: 16)),
        Text(
          'Tramos: ${itinerary.legs.length}',
          style: TextStyle(fontSize: 16),
        ),
        if (itinerary.agentRating != null)
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              Text('${itinerary.agentRating}'),
            ],
          ),
      ],
    );
  }
}
