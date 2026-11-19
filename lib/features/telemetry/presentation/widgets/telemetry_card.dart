import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/optical_reading.dart';
import '../../domain/entities/signal_status.dart';
import '../providers/telemetry_providers.dart';

class TelemetryCard extends ConsumerWidget {
  const TelemetryCard({super.key});

  Color _statusColor(SignalStatus status) {
    switch (status) {
      case SignalStatus.normal:
        return const Color(0xFF10B981);
      case SignalStatus.warning:
        return const Color(0xFFF59E0B);
      case SignalStatus.critical:
        return const Color(0xFFF43F5E);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingAsync = ref.watch(opticalReadingsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: readingAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const Center(
          child: Text(
            'Telemetry unavailable',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (OpticalReading reading) {
          final color = _statusColor(reading.status);

          final normalizedValue =
              ((reading.valueDbm + 35) / 25).clamp(0.0, 1.0);

          return Column(
            children: [
              const Text(
                'OPTICAL TELEMETRY FEED',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: normalizedValue,
                        strokeWidth: 12,
                        backgroundColor: const Color(0xFF263244),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          reading.valueDbm.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'dBm',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: color.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  reading.status.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Live Stream • Periodic 800ms sensor emission',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
