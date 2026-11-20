import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/queued_anomaly.dart';
import 'anomaly_providers.dart';

final anomalyQueueProvider =
    FutureProvider<List<QueuedAnomaly>>((ref) async {
  final repository = ref.watch(anomalyRepositoryProvider);

  return repository.getAllAnomalies();
});

final pendingQueueCountProvider = Provider<int>((ref) {
  final queue = ref.watch(anomalyQueueProvider);

  return queue.maybeWhen(
    data: (items) => items
        .where((item) => item.syncStatus == 'pending')
        .length,
    orElse: () => 0,
  );
});

final syncedQueueCountProvider = Provider<int>((ref) {
  final queue = ref.watch(anomalyQueueProvider);

  return queue.maybeWhen(
    data: (items) => items
        .where((item) => item.syncStatus == 'synced')
        .length,
    orElse: () => 0,
  );
});

final failedQueueCountProvider = Provider<int>((ref) {
  final queue = ref.watch(anomalyQueueProvider);

  return queue.maybeWhen(
    data: (items) => items
        .where((item) => item.syncStatus == 'failed')
        .length,
    orElse: () => 0,
  );
});
