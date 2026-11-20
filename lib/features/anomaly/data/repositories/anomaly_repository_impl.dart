import '../../domain/entities/odp_anomaly.dart';
import '../../domain/entities/queued_anomaly.dart';
import '../../domain/repositories/anomaly_repository.dart';
import '../datasources/anomaly_local_datasource.dart';
import '../models/anomaly_model.dart';

class AnomalyRepositoryImpl implements AnomalyRepository {
  final AnomalyLocalDataSource _localDataSource;

  AnomalyRepositoryImpl({
    AnomalyLocalDataSource? localDataSource,
  }) : _localDataSource =
            localDataSource ?? AnomalyLocalDataSource();

  @override
  Future<void> submitAnomaly(OdpAnomaly anomaly) async {
    final model = AnomalyModel.fromEntity(anomaly);
    await _localDataSource.insertAnomaly(model.toJson());
  }

  @override
  Future<List<QueuedAnomaly>> getPendingAnomalies() async {
    final records = await _localDataSource.getPendingAnomalies();

    return records.map((record) {
      final model = AnomalyModel.fromMap(record);

      return QueuedAnomaly(
        id: model.id!,
        anomaly: OdpAnomaly(
          odpCode: model.odpCode,
          signalDbm: model.signalDbm,
          category: model.category,
          notes: model.notes,
          createdAt: model.createdAt,
        ),
        syncStatus: model.syncStatus,
        retryCount: model.retryCount,
      );
    }).toList();
  }

  @override
  Future<void> updateSyncStatus(int id, String status) async {
    await _localDataSource.updateSyncStatus(id, status);
  }

  @override
  Future<void> incrementRetryCount(int id) async {
    await _localDataSource.incrementRetryCount(id);
  }
}
