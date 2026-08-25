import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/auth/session_controller.dart';
import 'package:control_entradas_salidas/core/router/app_shell.dart';

void main() {
  testWidgets('AppShell boots without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith((ref) => SessionController(null)
            ..state = const SessionState.unauthenticated()),
        ],
        child: const AppShell(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppShell), findsOneWidget);
  });
}
