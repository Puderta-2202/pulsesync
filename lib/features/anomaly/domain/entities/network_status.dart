enum NetworkStatus {
  online,
  unstable,
  offline;

  String get label {
    switch (this) {
      case NetworkStatus.online:
        return 'Online';
      case NetworkStatus.unstable:
        return 'Unstable';
      case NetworkStatus.offline:
        return 'Offline';
    }
  }
}
