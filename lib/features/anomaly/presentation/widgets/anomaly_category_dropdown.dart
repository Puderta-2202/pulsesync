import 'package:flutter/material.dart';

import '../../domain/entities/anomaly_category.dart';

class AnomalyCategoryDropdown extends StatelessWidget {
  final AnomalyCategory value;
  final ValueChanged<AnomalyCategory> onChanged;

  const AnomalyCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _getLabel(AnomalyCategory category) {
    switch (category) {
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

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnomalyCategory>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Kategori Anomali',
        prefixIcon: Icon(Icons.category_outlined),
        border: OutlineInputBorder(),
      ),
      items: AnomalyCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(_getLabel(category)),
        );
      }).toList(),
      onChanged: (category) {
        if (category != null) {
          onChanged(category);
        }
      },
      validator: (category) {
        if (category == null) {
          return 'Pilih kategori anomali';
        }
        return null;
      },
    );
  }
}
