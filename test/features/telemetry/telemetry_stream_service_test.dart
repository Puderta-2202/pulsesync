import 'package:flutter_test/flutter_test.dart';

import 'package:pulsesync/features/telemetry/data/services/telemetry_stream_service.dart';
import 'package:pulsesync/features/telemetry/domain/entities/signal_status.dart';
import 'dart:async';

void main() {
  group('SignalStatus Classification', () {
    test('Should classify normal signal correctly', () {
      expect(SignalStatus.fromDbm(-10.0), SignalStatus.normal);
      expect(SignalStatus.fromDbm(-18.5), SignalStatus.normal);
      expect(SignalStatus.fromDbm(-22.0), SignalStatus.normal);
    });

    test('Should classify warning signal correctly', () {
      expect(SignalStatus.fromDbm(-22.1), SignalStatus.warning);
      expect(SignalStatus.fromDbm(-25.0), SignalStatus.warning);
      expect(SignalStatus.fromDbm(-27.0), SignalStatus.warning);
    });

    test('Should classify critical signal correctly', () {
      expect(SignalStatus.fromDbm(-27.1), SignalStatus.critical);
      expect(SignalStatus.fromDbm(-30.0), SignalStatus.critical);
      expect(SignalStatus.fromDbm(-35.0), SignalStatus.critical);
    });
  });

  group('TelemetryStreamService', () {
    test('Should use 800ms interval by default', () {
      final service = TelemetryStreamService();

      expect(
        service.interval,
        const Duration(milliseconds: 800),
      );
    });

    test('Should generate readings within valid range', () async {
      final service = TelemetryStreamService(
        interval: Duration.zero,
      );

      final readings = await service
          .watchReadings()
          .take(20)
          .toList();

      for (final reading in readings) {
        expect(reading.valueDbm, greaterThanOrEqualTo(-35.0));
        expect(reading.valueDbm, lessThanOrEqualTo(-10.0));
      }
    });

    test('Should generate readings with one decimal precision', () async {
      final service = TelemetryStreamService(
        interval: Duration.zero,
      );

      final readings = await service
          .watchReadings()
          .take(20)
          .toList();

      for (final reading in readings) {
        final scaledValue = reading.valueDbm * 10;

        expect(
          scaledValue,
          closeTo(scaledValue.roundToDouble(), 0.000001),
        );
      }
    });

    test('Should emit readings approximately every 800ms', () async {
      final service = TelemetryStreamService();

      final readings = await service
          .watchReadings()
          .take(2)
          .toList();

      final difference = readings[1]
          .timestamp
          .difference(readings[0].timestamp);

      expect(
        difference.inMilliseconds,
        greaterThanOrEqualTo(750),
      );

      expect(
        difference.inMilliseconds,
        lessThan(1200),
      );
    });
    test('Should stop emitting readings after subscription cancellation', () async {
        final service = TelemetryStreamService();

        final firstReading = Completer<void>();
        var emissionCount = 0;

        final subscription = service.watchReadings().listen((_) {
            emissionCount++;

            if (!firstReading.isCompleted) {
            firstReading.complete();
            }
        });

        await firstReading.future.timeout(
            const Duration(seconds: 2),
        );

        await subscription.cancel();

        final countAfterCancellation = emissionCount;

        await Future.delayed(
            const Duration(milliseconds: 900),
        );

        expect(emissionCount, countAfterCancellation);

        expect(emissionCount, 1);
        });
  });
}
