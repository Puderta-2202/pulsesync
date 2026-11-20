import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/repositories/anomaly_repository_impl.dart';
import '../../data/services/anomaly_sync_service.dart';
import '../../data/services/network_simulator_service.dart';
import '../../domain/entities/network_status.dart';
import '../../domain/repositories/anomaly_repository.dart';
import '../../domain/usecases/submit_anomaly.dart';

final anomalyRepositoryProvider = Provider<AnomalyRepository>((ref) {
  return AnomalyRepositoryImpl();
});

final submitAnomalyProvider = Provider<SubmitAnomaly>((ref) {
  final repository = ref.watch(anomalyRepositoryProvider);
  return SubmitAnomaly(repository);
});

// Status jaringan yang dipilih pada dashboard.
final networkStatusProvider = StateProvider<NetworkStatus>((ref) {
  return NetworkStatus.online;
});

// Network Simulator.
final networkSimulatorProvider = Provider<NetworkSimulatorService>((ref) {
  return NetworkSimulatorService();
});

// Queue Sync Service.
final anomalySyncServiceProvider = Provider<AnomalySyncService>((ref) {
  final repository = ref.watch(anomalyRepositoryProvider);
  final networkSimulator = ref.watch(networkSimulatorProvider);

  return AnomalySyncService(
    repository: repository,
    networkSimulator: networkSimulator,
  );
});
