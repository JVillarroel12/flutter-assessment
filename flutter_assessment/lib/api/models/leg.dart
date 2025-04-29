class Leg {
  final String id;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int stops;
  final String airlineName;
  final String airlineId;
  final int durationMins;

  Leg({
    required this.id,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.airlineName,
    required this.airlineId,
    required this.durationMins,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      id: json['id'],
      departureAirport: json['departure_airport'],
      arrivalAirport: json['arrival_airport'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      stops: json['stops'],
      airlineName: json['airline_name'],
      airlineId: json['airline_id'],
      durationMins: json['duration_mins'],
    );
  }
}
