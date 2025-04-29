import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flights.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 7, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE itineraries (
        id TEXT PRIMARY KEY,
        price TEXT NOT NULL,
        agent TEXT NOT NULL,
        agent_rating REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE legs (
        id TEXT PRIMARY KEY,
        departure_airport TEXT NOT NULL,
        arrival_airport TEXT NOT NULL,
        departure_time TEXT NOT NULL,
        arrival_time TEXT NOT NULL,
        stops INTEGER NOT NULL,
        airline_name TEXT NOT NULL,
        airline_id TEXT NOT NULL,
        duration_mins INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE itinerary_legs (
        itinerary_id TEXT NOT NULL,
        leg_id TEXT NOT NULL,
        FOREIGN KEY (itinerary_id) REFERENCES itineraries(id) ON DELETE CASCADE,
        FOREIGN KEY (leg_id) REFERENCES legs(id) ON DELETE CASCADE,
        PRIMARY KEY (itinerary_id, leg_id)
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
