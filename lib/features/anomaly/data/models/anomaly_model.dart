import '../../domain/entities/odp_anomaly.dart';

class AnomalyModel extends OdpAnomaly {
  const AnomalyModel({
    required super.odpCode,
    required super.signalDbm,
    required super.category,
    required super.notes,
    required super.createdAt,
  });

  factory AnomalyModel.fromEntity(OdpAnomaly anomaly) {
    return AnomalyModel(
      odpCode: anomaly.odpCode,
      signalDbm: anomaly.signalDbm,
      category: anomaly.category,
      notes: anomaly.notes,
      createdAt: anomaly.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'odp_code': odpCode,
      'signal_dbm': signalDbm,
      'category': category.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
