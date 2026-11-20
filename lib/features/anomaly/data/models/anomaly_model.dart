import '../../domain/entities/anomaly_category.dart';
import '../../domain/entities/odp_anomaly.dart';

class AnomalyModel extends OdpAnomaly {
  final int? id;
  final String syncStatus;
  final int retryCount;

  const AnomalyModel({
    this.id,
    this.syncStatus = 'pending',
    this.retryCount = 0,
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

  factory AnomalyModel.fromMap(Map<String, Object?> map) {
    return AnomalyModel(
      id: map['id'] as int,
      odpCode: map['odp_code'] as String,
      signalDbm: (map['signal_dbm'] as num).toDouble(),
      category: AnomalyCategory.values.byName(
        map['category'] as String,
      ),
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      syncStatus: map['sync_status'] as String,
      retryCount: map['retry_count'] as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'odp_code': odpCode,
      'signal_dbm': signalDbm,
      'category': category.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'sync_status': syncStatus,
      'retry_count': retryCount,
    };
  }
}
