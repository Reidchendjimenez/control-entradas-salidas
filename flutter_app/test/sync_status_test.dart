import 'package:control_entradas_salidas/core/sync/sync_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncStatusNotifier', () {
    test('inactivo por defecto', () {
      final n = SyncStatusNotifier();
      expect(n.state.visible, isFalse);
      n.dispose();
    });

    test('iniciar muestra la barra en estado activo', () {
      final n = SyncStatusNotifier();
      n.iniciar(SyncOrigen.general);
      expect(n.state.visible, isTrue);
      expect(n.state.estado, SyncEstado.activo);
      expect(n.state.origen, SyncOrigen.general);
      n.dispose();
    });

    test('ignora mensajes de origenes sin sesion activa', () {
      final n = SyncStatusNotifier();
      n.progreso(SyncOrigen.general, 'tabla descargada');
      expect(n.state.visible, isFalse);
      n.dispose();
    });

    test('progreso activo actualiza el mensaje', () {
      final n = SyncStatusNotifier();
      n.iniciar(SyncOrigen.pos);
      n.progreso(SyncOrigen.pos, 'pos_settings descargado');
      expect(n.state.estado, SyncEstado.activo);
      expect(n.state.mensaje, 'pos_settings descargado');
      n.dispose();
    });

    test('mensaje de finalizacion marca ok y cierra la sesion', () {
      final n = SyncStatusNotifier();
      n.iniciar(SyncOrigen.general);
      n.progreso(SyncOrigen.general, 'Sincronización completa finalizada');
      expect(n.state.estado, SyncEstado.ok);
      expect(n.state.mensaje, startsWith('Sincronización completa'));
      n.terminar(SyncOrigen.general, ok: true);
      expect(n.state.estado, SyncEstado.ok);
      n.dispose();
    });

    test('mensaje con Error marca error y cierra la sesion', () {
      final n = SyncStatusNotifier();
      n.iniciar(SyncOrigen.pos);
      n.progreso(SyncOrigen.pos, 'Error descargando mesa: timeout');
      expect(n.state.estado, SyncEstado.error);
      expect(n.state.mensaje, contains('Error descargando mesa'));
      n.progreso(SyncOrigen.pos, 'tabla descargada');
      expect(n.state.estado, SyncEstado.error);
      n.dispose();
    });

    test('terminar es respaldo cuando el motor no emitio finalizacion', () {
      final n = SyncStatusNotifier();
      n.iniciar(SyncOrigen.general);
      n.terminar(SyncOrigen.general, ok: false);
      expect(n.state.estado, SyncEstado.error);
      expect(n.state.mensaje, 'Error en la sincronización');
      n.dispose();
    });

    test('terminar sin sesion previa es no-op', () {
      final n = SyncStatusNotifier();
      n.terminar(SyncOrigen.general, ok: true);
      expect(n.state.visible, isFalse);
      n.dispose();
    });
  });
}
