enum SignalStatus {
  normal,
  warning,
  critical;

  String get label {
    switch (this) {
      case SignalStatus.normal:
        return 'NORMAL SIGNAL';
      case SignalStatus.warning:
        return 'WARNING / MARGINAL';
      case SignalStatus.critical:
        return 'CRITICAL LOSS';
    }
  }

  static SignalStatus fromDbm(double value) {
    if (value >= -22.0) {
      return SignalStatus.normal;
    }

    if (value >= -27.0) {
      return SignalStatus.warning;
    }

    return SignalStatus.critical;
  }
}
