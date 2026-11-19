import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulsesync/main.dart';

void main() {
  testWidgets('PulseSync dashboard renders successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PulseSyncApp(),
      ),
    );

    expect(find.text('PulseSync Monitor'), findsOneWidget);
    expect(find.text('Optical Network Monitoring'), findsOneWidget);
    expect(find.text('ONLINE'), findsOneWidget);
    expect(find.text('CATAT ANOMALI ODP BARU'), findsOneWidget);

    // Dispose the widget tree to trigger Riverpod autoDispose.
    await tester.pumpWidget(
      const SizedBox.shrink(),
    );

    // Allow the pending telemetry timer to complete.
    await tester.pump(
      const Duration(milliseconds: 800),
    );

    await tester.pump();
  });
}
