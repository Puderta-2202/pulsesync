import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/services/telemetry_stream_service.dart';
import '../../domain/entities/optical_reading.dart';

final telemetryStreamServiceProvider =
    Provider<TelemetryStreamService>((ref) {
  return TelemetryStreamService();
});

// Mengontrol apakah stream telemetry sedang dibutuhkan.
final telemetryEnabledProvider = StateProvider<bool>((ref) {
  return true;
});

final opticalReadingsProvider =
    StreamProvider.autoDispose<OpticalReading>((ref) {
  final isEnabled = ref.watch(telemetryEnabledProvider);

  if (!isEnabled) {
    return const Stream<OpticalReading>.empty();
  }

  final service = ref.watch(telemetryStreamServiceProvider);

  return service.watchReadings();
});
