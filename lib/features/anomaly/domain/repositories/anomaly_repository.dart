import '../entities/odp_anomaly.dart';
import '../entities/queued_anomaly.dart';

abstract class AnomalyRepository {
  /// Menyimpan laporan anomali ke antrean lokal.
  Future<void> submitAnomaly(OdpAnomaly anomaly);

  /// Mengambil seluruh antrean yang masih pending berdasarkan FIFO.
  Future<List<QueuedAnomaly>> getPendingAnomalies();

  Future<List<QueuedAnomaly>> getAllAnomalies();

  /// Memperbarui status sinkronisasi suatu antrean.
  Future<void> updateSyncStatus(int id, String status);

  /// Menambah jumlah percobaan pengiriman.
  Future<void> incrementRetryCount(int id);
}
