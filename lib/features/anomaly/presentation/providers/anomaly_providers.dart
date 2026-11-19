import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/anomaly_repository_impl.dart';
import '../../domain/repositories/anomaly_repository.dart';
import '../../domain/usecases/submit_anomaly.dart';

/// Repository Provider
final anomalyRepositoryProvider =
    Provider<AnomalyRepository>((ref) {
  return AnomalyRepositoryImpl();
});

/// Submit Anomaly Use Case Provider
final submitAnomalyProvider =
    Provider<SubmitAnomaly>((ref) {
  final repository = ref.watch(anomalyRepositoryProvider);

  return SubmitAnomaly(repository);
});
