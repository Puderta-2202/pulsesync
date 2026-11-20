import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';

class AnomalyLocalDataSource {
  final AppDatabase _appDatabase;

  AnomalyLocalDataSource({
    AppDatabase? appDatabase,
  }) : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<int> insertAnomaly(Map<String, Object?> data) async {
    final Database db = await _appDatabase.database;

    return db.insert(
      'anomalies',
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, Object?>>> getAllAnomalies() async {
    final Database db = await _appDatabase.database;

    return db.query(
      'anomalies',
      orderBy: 'created_at DESC',
    );
  }
}
