import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/main_navigation_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PulseSyncApp(),
    ),
  );
}

class PulseSyncApp extends StatelessWidget {
  const PulseSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PulseSync',
      theme: ThemeData.dark(),
      home: const MainNavigationScreen(),
    );
  }
}
