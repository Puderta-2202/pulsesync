import 'signal_status.dart';

class OpticalReading {
  final double valueDbm;
  final DateTime timestamp;

  const OpticalReading({
    required this.valueDbm,
    required this.timestamp,
  });

  SignalStatus get status {
    return SignalStatus.fromDbm(valueDbm);
  }
}
