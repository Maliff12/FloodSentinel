import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'water_level.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE WaterLevels (
        id INTEGER PRIMARY KEY,
        areaName TEXT,
        waterLevel INTEGER,
        rateOfChange INTEGER
      )
    ''');
  }

  Future<int> insertWaterLevel(Map<String, dynamic> row) async {
    Database dbClient = await db;
    return await dbClient.insert('WaterLevels', row);
  }

  Future<List<Map<String, dynamic>>> getAllWaterLevels() async {
    Database dbClient = await db;
    return await dbClient.query('WaterLevels');
  }
}
