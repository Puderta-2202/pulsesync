import 'dart:async';
import 'dart:math';

import '../../domain/entities/network_status.dart';

class NetworkSimulationException implements Exception {
  final String message;

  const NetworkSimulationException(this.message);

  @override
  String toString() => message;
}

class NetworkSimulatorService {
  final Random _random;
  final Duration _responseDelay;

  NetworkSimulatorService({
    Random? random,
    Duration responseDelay = const Duration(milliseconds: 400),
  })  : _random = random ?? Random(),
        _responseDelay = responseDelay;

  Future<void> send(NetworkStatus status) async {
    switch (status) {
      case NetworkStatus.online:
        await Future.delayed(_responseDelay);
        return;

      case NetworkStatus.unstable:
        await Future.delayed(_responseDelay);

        // Simulasi peluang kegagalan sebesar 50%.
        if (_random.nextBool()) {
          throw const NetworkSimulationException(
            'Simulasi jaringan tidak stabil: request timeout.',
          );
        }

        return;

      case NetworkStatus.offline:
        throw const NetworkSimulationException(
          'Tidak ada koneksi internet.',
        );
    }
  }
}
