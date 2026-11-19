import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outpost/core/constants/triage_enums.dart';
import 'package:outpost/main.dart';
import 'package:outpost/presentation/widgets/offline_status_banner.dart';
import 'package:outpost/presentation/widgets/symptom_card.dart';
import 'package:outpost/presentation/widgets/triage_badge.dart';

void main() {
  testWidgets('OutpostApp boots and displays initial welcome and language selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OutpostApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Outpost branding and language selector
    expect(find.text('outpost'), findsOneWidget);
    expect(find.text('বাংলা'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.byType(OfflineStatusBanner), findsOneWidget);
  });

  testWidgets('TriageBadge displays correct colors and text for Emergency',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: TriageBadge(level: TriageLevel.emergency),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('জরুরি · Emergency'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('SymptomCard renders label and responds to selection',
      (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SymptomCard(
            id: 'chest_pain',
            label: 'বুকে ব্যথা',
            icon: Icons.favorite_rounded,
            isSelected: true,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('বুকে ব্যথা'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.tap(find.byType(SymptomCard));
    expect(tapped, isTrue);
  });
}
