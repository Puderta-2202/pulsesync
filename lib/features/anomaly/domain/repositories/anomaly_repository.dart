import '../entities/odp_anomaly.dart';

abstract class AnomalyRepository {
  Future<void> submitAnomaly(OdpAnomaly anomaly);
}
