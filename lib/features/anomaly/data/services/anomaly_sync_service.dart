import '../../domain/entities/network_status.dart';
import '../../domain/repositories/anomaly_repository.dart';
import 'network_simulator_service.dart';

class AnomalySyncService {
  final AnomalyRepository _repository;
  final NetworkSimulatorService _networkSimulator;

  bool _isSyncing = false;

  AnomalySyncService({
    required AnomalyRepository repository,
    required NetworkSimulatorService networkSimulator,
  })  : _repository = repository,
        _networkSimulator = networkSimulator;

  bool get isSyncing => _isSyncing;

  Future<void> syncPendingQueue(NetworkStatus networkStatus) async {
    // Jangan mengirim data ketika jaringan Offline.
    if (networkStatus == NetworkStatus.offline) return;

    // Mencegah proses sinkronisasi berjalan bersamaan.
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      final pendingAnomalies =
          await _repository.getPendingAnomalies();

      // Memproses antrean secara berurutan (FIFO).
      for (final queuedAnomaly in pendingAnomalies) {
        var attemptsMade = queuedAnomaly.retryCount;

        while (attemptsMade < 3) {
          try {
            await _networkSimulator.send(networkStatus);

            await _repository.updateSyncStatus(
              queuedAnomaly.id,
              'synced',
            );

            // Berhasil, lanjut ke antrean berikutnya.
            break;
          } on NetworkSimulationException {
            await _repository.incrementRetryCount(
              queuedAnomaly.id,
            );

            attemptsMade++;

            if (attemptsMade >= 3) {
              await _repository.updateSyncStatus(
                queuedAnomaly.id,
                'failed',
              );

              // Batas percobaan tercapai.
              break;
            }

            // Exponential backoff: 1 detik, kemudian 2 detik.
            final delaySeconds = 1 << (attemptsMade - 1);

            await Future.delayed(
              Duration(seconds: delaySeconds),
            );
          }
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
