import '../../domain/entities/odp_anomaly.dart';
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
}
