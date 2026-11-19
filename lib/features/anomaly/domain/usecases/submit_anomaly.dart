import '../entities/odp_anomaly.dart';
import '../repositories/anomaly_repository.dart';

class SubmitAnomaly {
  final AnomalyRepository repository;

  const SubmitAnomaly(this.repository);

  Future<void> call(OdpAnomaly anomaly) {
    return repository.submitAnomaly(anomaly);
  }
}
