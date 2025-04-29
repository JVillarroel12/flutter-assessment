import 'package:flutter_assessment/api/models/leg.dart';
import 'package:flutter_assessment/database/database.dart';
import 'package:sqflite/sqflite.dart';

class LegDao {
  final AppDatabase _database;

  LegDao(this._database);

  Future<void> insertLeg(Leg leg) async {
    final db = await _database.database;

    await db.insert('legs', {
      'id': leg.id,
      'departure_airport': leg.departureAirport,
      'arrival_airport': leg.arrivalAirport,
      'departure_time': leg.departureTime.toIso8601String(),
      'arrival_time': leg.arrivalTime.toIso8601String(),
      'stops': leg.stops,
      'airline_name': leg.airlineName,
      'airline_id': leg.airlineId,
      'duration_mins': leg.durationMins,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Leg>> getAllLegs() async {
    final db = await _database.database;
    final legs = await db.query('legs');

    return legs
        .map(
          (leg) => Leg(
            id: leg['id'] as String,
            departureAirport: leg['departure_airport'] as String,
            arrivalAirport: leg['arrival_airport'] as String,
            departureTime: DateTime.parse(leg['departure_time'] as String),
            arrivalTime: DateTime.parse(leg['arrival_time'] as String),
            stops: leg['stops'] as int,
            airlineName: leg['airline_name'] as String,
            airlineId: leg['airline_id'] as String,
            durationMins: leg['duration_mins'] as int,
          ),
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllAirlinesWithLegCount() async {
    final db = await _database.database;
    return await db.rawQuery('''
    SELECT 
      airline_id, 
      airline_name, 
      COUNT(*) as leg_count 
    FROM legs 
    GROUP BY airline_id, airline_name 
    ORDER BY leg_count DESC
  ''');
  }

  Future<List<Leg>> getLegsByIds(List<String> legIds) async {
    final db = await _database.database;
    final legs = await db.query(
      'legs',
      where: 'id IN (${List.filled(legIds.length, '?').join(',')})',
      whereArgs: legIds,
    );

    return legs.map((leg) => Leg.fromJson(leg)).toList();
  }
}
