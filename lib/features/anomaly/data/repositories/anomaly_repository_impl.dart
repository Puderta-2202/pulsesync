import '../../domain/entities/odp_anomaly.dart';
import '../../domain/repositories/anomaly_repository.dart';
import '../models/anomaly_model.dart';

class AnomalyRepositoryImpl implements AnomalyRepository {
  final List<AnomalyModel> _anomalies = [];

  @override
  Future<void> submitAnomaly(OdpAnomaly anomaly) async {
    final model = AnomalyModel.fromEntity(anomaly);

    _anomalies.add(model);
  }
}
