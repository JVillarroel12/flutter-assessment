import 'dart:convert';
import 'package:flutter_assessment/api/models/itinerary.dart';
import 'package:flutter_assessment/api/models/leg.dart';
import 'package:http/http.dart' as http;

class FlightApi {
  static const String flightsUrl =
      'https://raw.githubusercontent.com/Skyscanner/full-stack-recruitment-test/main/public/flights.json';

  Future<Map<String, dynamic>> fetchFlightData() async {
    final response = await http.get(Uri.parse(flightsUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load flight data");
    }
  }

  Future<List<Itinerary>> fetchItineraries() async {
    final data = await fetchFlightData();
    final itinerariesJson = data['itineraries'] as List;
    return itinerariesJson.map((json) => Itinerary.fromJson(json)).toList();
  }

  Future<List<Leg>> fetchLegs() async {
    final data = await fetchFlightData();
    final legsJson = data['legs'] as List;
    return legsJson.map((json) => Leg.fromJson(json)).toList();
  }

  Future<Map<String, Leg>> fetchLegsMap() async {
    final legs = await fetchLegs();
    return {for (var leg in legs) leg.id: leg};
  }
}
