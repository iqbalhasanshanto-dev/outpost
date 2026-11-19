import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outpost/main.dart';

void main() {
  testWidgets('OutpostApp boots and displays initial language selection',
      (WidgetTester tester) async {
    // Build Outpost with root ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: OutpostApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Outpost brand title and initial language options are rendered.
    expect(find.text('outpost'), findsOneWidget);
    expect(find.text('বাংলা'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });
}
