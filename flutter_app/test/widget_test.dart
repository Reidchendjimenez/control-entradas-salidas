import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/database_provider.dart';
import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/core/router/app_shell.dart';

void main() {
  testWidgets('AppShell boots without crashing', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async => db.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const AppShell(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppShell), findsOneWidget);
  });
}
