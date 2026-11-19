import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/anomaly_category.dart';
import '../../domain/entities/odp_anomaly.dart';
import '../providers/anomaly_providers.dart';
import 'anomaly_category_dropdown.dart';

class AnomalyForm extends ConsumerStatefulWidget {
  final double signalDbm;

  const AnomalyForm({
    super.key,
    required this.signalDbm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required double signalDbm,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AnomalyForm(signalDbm: signalDbm),
    );
  }

  @override
  ConsumerState<AnomalyForm> createState() => _AnomalyFormState();
}

class _AnomalyFormState extends ConsumerState<AnomalyForm> {
  final _formKey = GlobalKey<FormState>();
  final _odpController = TextEditingController();
  final _notesController = TextEditingController();

  AnomalyCategory _selectedCategory = AnomalyCategory.values.first;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _odpController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final anomaly = OdpAnomaly(
      odpCode: _odpController.text.trim(),
      signalDbm: widget.signalDbm,
      category: _selectedCategory,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(submitAnomalyProvider).call(anomaly);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan anomali: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Catat Anomali ODP',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Lengkapi informasi gangguan jaringan optik.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),

              const SizedBox(height: 24),

              // Locked telemetry snapshot
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.sensors,
                    color: Colors.green,
                  ),
                  title: const Text('Snapshot Optical Signal'),
                  subtitle: const Text(
                    'Nilai terkunci saat form dibuka',
                  ),
                  trailing: Text(
                    '${widget.signalDbm.toStringAsFixed(1)} dBm',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _odpController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Kode ODP',
                  hintText: 'Contoh: ODP-SBY-001',
                  prefixIcon: Icon(Icons.router_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode ODP wajib diisi';
                  }

                  if (value.trim().length < 4) {
                    return 'Kode ODP minimal 4 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              AnomalyCategoryDropdown(
                value: _selectedCategory,
                onChanged: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan Teknisi',
                  hintText: 'Jelaskan kondisi atau temuan di lapangan...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _isSubmitting
                        ? 'Menyimpan...'
                        : 'SIMPAN LAPORAN',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
