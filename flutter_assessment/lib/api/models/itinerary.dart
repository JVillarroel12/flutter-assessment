class Itinerary {
  final String id;
  final List<String> legs;
  final String price;
  final String agent;
  final double? agentRating;

  Itinerary({
    required this.id,
    required this.legs,
    required this.price,
    required this.agent,
    required this.agentRating,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      legs: List<String>.from(['legs']),
      price: json['price'],
      agent: json['agent'],
      agentRating: json['agentRating'],
    );
  }
}
