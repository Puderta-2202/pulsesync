import 'dart:math';

import '../../domain/entities/optical_reading.dart';

class TelemetryStreamService {
  final Random _random;
  final Duration interval;

  TelemetryStreamService({
    Random? random,
    this.interval = const Duration(milliseconds: 800),
  }) : _random = random ?? Random();

  Stream<OpticalReading> watchReadings() async* {
    while (true) {
      await Future.delayed(interval);

      final rawValue = -35.0 + (_random.nextDouble() * 25.0);

      final valueDbm = double.parse(
        rawValue.toStringAsFixed(1),
      );

      yield OpticalReading(
        valueDbm: valueDbm,
        timestamp: DateTime.now(),
      );
    }
  }
}
