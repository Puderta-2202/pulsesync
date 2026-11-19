enum AnomalyCategory {
  macroBending,
  dirtyConnector,
  brokenCore,
  highAttenuation;

  String get label {
    switch (this) {
      case AnomalyCategory.macroBending:
        return 'Kabel Bengkok / Macro-bending';
      case AnomalyCategory.dirtyConnector:
        return 'Konektor Kotor';
      case AnomalyCategory.brokenCore:
        return 'Core Putus';
      case AnomalyCategory.highAttenuation:
        return 'Redaman Tinggi';
    }
  }
}