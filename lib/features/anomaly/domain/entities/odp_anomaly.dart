import 'anomaly_category.dart';

class OdpAnomaly {
  final String odpCode;
  final double signalDbm;
  final AnomalyCategory category;
  final String notes;
  final DateTime createdAt;

  const OdpAnomaly({
    required this.odpCode,
    required this.signalDbm,
    required this.category,
    required this.notes,
    required this.createdAt,
  });
}