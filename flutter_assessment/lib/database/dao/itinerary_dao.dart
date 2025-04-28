import 'package:flutter_assessment/api/models/itinerary.dart';
import 'package:flutter_assessment/database/database.dart';
import 'package:sqflite/sqflite.dart';

class ItineraryDao {
  final AppDataBase _dataBase;

  ItineraryDao(this._dataBase);

  Future<void> insertItineraryWithLegs(
    Itinerary itinerary,
    List<String> legIds,
  ) async {
    final db = await _dataBase.database;

    await db.insert('itineraries', {
      'id': itinerary.id,
      'price': itinerary.price,
      'agent': itinerary.agent,
      'agent_rating': itinerary.agentRating,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    for (final legId in legIds) {
      await db.insert('itinerary_legs', {
        'itinerary_id': itinerary.id,
        'leg_id': legId,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Itinerary>> getAllItinerariesWithLegs() async {
    final db = await _dataBase.database;
    final itineraries = await db.query('itineraries');

    final itineraryList = <Itinerary>[];

    for (final itineraryMap in itineraries) {
      final legs = await db.rawQuery(
        '''
            SELECT l.* FROM legs l
      JOIN itinerary_legs il ON l.id = il.leg_id
      WHERE il.itinerary_id = ?
''',
        [itineraryMap['id']],
      );
      itineraryList.add(
        Itinerary(
          id: itineraryMap['id'] as String,
          legs: legs.map((leg) => leg['id'] as String).toList(),
          price: itineraryMap['price'] as String,
          agent: itineraryMap['agent'] as String,
          agentRating: itineraryMap['agent_rating'] as double?,
        ),
      );
    }
    return itineraryList;
  }
}
