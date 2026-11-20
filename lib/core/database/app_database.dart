import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'pulsesync.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE anomalies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            odp_code TEXT NOT NULL,
            signal_dbm REAL NOT NULL,
            category TEXT NOT NULL,
            notes TEXT,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }
}