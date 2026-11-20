import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../anomaly/presentation/providers/anomaly_providers.dart';
import '../../anomaly/presentation/providers/anomaly_queue_providers.dart';
import '../../anomaly/presentation/widgets/anomaly_form.dart';
import '../../anomaly/domain/entities/network_status.dart';
import 'providers/telemetry_providers.dart';
import 'widgets/telemetry_card.dart';

class TelemetryDashboardScreen extends ConsumerWidget {
  const TelemetryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    // Sinkronisasi otomatis ketika jaringan berubah Offline -> Online.
    ref.listen<NetworkStatus>(
      networkStatusProvider,
      (previous, next) async {
        if (previous == NetworkStatus.offline &&
            next == NetworkStatus.online) {
          await _syncQueue(ref);
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PulseSync Monitor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Optical Network Monitoring',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  _NetworkBadge(status: networkStatus),
                ],
              ),

              const SizedBox(height: 32),

              const TelemetryCard(),

              const SizedBox(height: 28),

              _sectionTitle('NETWORK SIMULATOR'),
              const SizedBox(height: 12),

              DropdownButtonFormField<NetworkStatus>(
                initialValue: networkStatus,
                dropdownColor: const Color(0xFF1E293B),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                items: NetworkStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  );
                }).toList(),
                onChanged: (status) {
                  if (status != null) {
                    ref.read(networkStatusProvider.notifier).state =
                        status;
                  }
                },
              ),

              const SizedBox(height: 28),

              _sectionTitle('SYNC QUEUE MONITOR'),
              const SizedBox(height: 12),

              _QueueMonitor(),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: networkStatus == NetworkStatus.offline
                      ? null
                      : () => _syncQueue(ref),
                  icon: const Icon(Icons.sync),
                  label: const Text('SYNC NOW'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0284C7)),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final reading =
                        ref.read(opticalReadingsProvider).asData?.value;

                    if (reading == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Data telemetry belum tersedia',
                          ),
                        ),
                      );
                      return;
                    }

                    final result = await AnomalyForm.show(
                      context,
                      signalDbm: reading.valueDbm,
                    );

                    if (result == true) {
                      ref.invalidate(anomalyQueueProvider);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('CATAT ANOMALI ODP BARU'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _syncQueue(WidgetRef ref) async {
    final status = ref.read(networkStatusProvider);

    if (status == NetworkStatus.offline) return;

    final syncService = ref.read(anomalySyncServiceProvider);

    await syncService.syncPendingQueue(status);

    ref.invalidate(anomalyQueueProvider);
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _NetworkBadge extends StatelessWidget {
  final NetworkStatus status;

  const _NetworkBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      NetworkStatus.online => const Color(0xFF10B981),
      NetworkStatus.unstable => const Color(0xFFF59E0B),
      NetworkStatus.offline => const Color(0xFFEF4444),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _QueueMonitor extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingQueueCountProvider);
    final synced = ref.watch(syncedQueueCountProvider);
    final failed = ref.watch(failedQueueCountProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _QueueItem(
            label: 'PENDING',
            count: pending,
            color: const Color(0xFFF59E0B),
          ),
          _QueueItem(
            label: 'SYNCED',
            count: synced,
            color: const Color(0xFF10B981),
          ),
          _QueueItem(
            label: 'FAILED',
            count: failed,
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

class _QueueItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _QueueItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}