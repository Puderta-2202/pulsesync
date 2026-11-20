import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';

class AnomalyLocalDataSource {
  final AppDatabase _appDatabase;

  AnomalyLocalDataSource({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<int> insertAnomaly(Map<String, Object?> data) async {
    final Database db = await _appDatabase.database;

    return db.insert(
      'anomalies',
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Mengambil seluruh anomali yang masih menunggu sinkronisasi.
  /// Urutan berdasarkan ID agar FIFO (First In, First Out).
  Future<List<Map<String, Object?>>> getPendingAnomalies() async {
    final Database db = await _appDatabase.database;

    return db.query(
      'anomalies',
      where: 'sync_status = ?',
      whereArgs: ['pending'],
      orderBy: 'id ASC',
    );
  }

  /// Memperbarui status sinkronisasi anomali.
  Future<int> updateSyncStatus(int id, String status) async {
    final Database db = await _appDatabase.database;

    return db.update(
      'anomalies',
      {'sync_status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Menambah jumlah percobaan retry sebanyak satu.
  Future<int> incrementRetryCount(int id) async {
    final Database db = await _appDatabase.database;

    return db.rawUpdate(
      '''
      UPDATE anomalies
      SET retry_count = retry_count + 1
      WHERE id = ?
      ''',
      [id],
    );
  }

  /// Mengambil seluruh data anomali.
  Future<List<Map<String, Object?>>> getAllAnomalies() async {
    final Database db = await _appDatabase.database;

    return db.query(
      'anomalies',
      orderBy: 'created_at DESC',
    );
  }
}
