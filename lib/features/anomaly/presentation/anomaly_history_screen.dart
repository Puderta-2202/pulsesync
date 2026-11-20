import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/queued_anomaly.dart';
import 'providers/anomaly_queue_providers.dart';

class AnomalyHistoryScreen extends ConsumerWidget {
  const AnomalyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(anomalyQueueProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1120),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1120),
          title: const Text(
            'Anomaly History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF0284C7),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Failed'),
              Tab(text: 'Synced'),
            ],
          ),
        ),
        body: queueAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => const Center(
            child: Text(
              'Gagal memuat riwayat laporan.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          data: (reports) {
            return TabBarView(
              children: [
                _StatusHistoryList(
                  reports: reports,
                  status: 'pending',
                  emptyMessage: 'Tidak ada laporan pending.',
                ),
                _StatusHistoryList(
                  reports: reports,
                  status: 'failed',
                  emptyMessage: 'Tidak ada laporan failed.',
                ),
                _StatusHistoryList(
                  reports: reports,
                  status: 'synced',
                  emptyMessage: 'Belum ada laporan synced.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatusHistoryList extends StatelessWidget {
  final List<QueuedAnomaly> reports;
  final String status;
  final String emptyMessage;

  const _StatusHistoryList({
    required this.reports,
    required this.status,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final filteredReports = reports
        .where((report) => report.syncStatus == status)
        .toList();

    if (filteredReports.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        return _AnomalyHistoryCard(
          report: filteredReports[index],
        );
      },
    );
  }
}

class _AnomalyHistoryCard extends StatelessWidget {
  final QueuedAnomaly report;

  const _AnomalyHistoryCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final anomaly = report.anomaly;

    final statusColor = switch (report.syncStatus) {
      'synced' => const Color(0xFF10B981),
      'failed' => const Color(0xFFEF4444),
      _ => const Color(0xFFF59E0B),
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  anomaly.odpCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  report.syncStatus.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _HistoryInfo(
            label: 'Signal',
            value: '${anomaly.signalDbm.toStringAsFixed(1)} dBm',
          ),
          _HistoryInfo(
            label: 'Category',
            value: anomaly.category.name,
          ),
          _HistoryInfo(
            label: 'Notes',
            value: anomaly.notes.isEmpty ? '-' : anomaly.notes,
          ),
          _HistoryInfo(
            label: 'Created',
            value: anomaly.createdAt.toLocal().toString().split('.').first,
          ),
          _HistoryInfo(
            label: 'Retry attempts',
            value: report.retryCount.toString(),
          ),
        ],
      ),
    );
  }
}

class _HistoryInfo extends StatelessWidget {
  final String label;
  final String value;

  const _HistoryInfo({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
