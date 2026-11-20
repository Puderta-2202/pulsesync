import 'odp_anomaly.dart';

class QueuedAnomaly {
  final int id;
  final OdpAnomaly anomaly;
  final String syncStatus;
  final int retryCount;

  const QueuedAnomaly({
    required this.id,
    required this.anomaly,
    required this.syncStatus,
    required this.retryCount,
  });
}
