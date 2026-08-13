import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/router/app_shell.dart';

void main() {
  testWidgets('AppShell boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppShell(),
      ),
    );
    await tester.pump();

    expect(find.byType(AppShell), findsOneWidget);
  });
}
