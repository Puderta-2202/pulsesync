import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/anomaly/presentation/anomaly_history_screen.dart';
import '../features/telemetry/presentation/telemetry_dashboard_screen.dart';
import '../features/telemetry/presentation/providers/telemetry_providers.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    TelemetryDashboardScreen(),
    AnomalyHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          ref.read(telemetryEnabledProvider.notifier).state =
              index == 0;
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
