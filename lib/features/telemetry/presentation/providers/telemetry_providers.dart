import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/telemetry_stream_service.dart';
import '../../domain/entities/optical_reading.dart';

final telemetryStreamServiceProvider =
    Provider<TelemetryStreamService>((ref) {
  return TelemetryStreamService();
});

final opticalReadingsProvider =
    StreamProvider.autoDispose<OpticalReading>((ref) {
  final service = ref.watch(telemetryStreamServiceProvider);

  return service.watchReadings();
});
