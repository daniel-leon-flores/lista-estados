// IA: pruebas de widget generadas con Claude (Anthropic); ejecutadas con
// `flutter test`. Se usa tester.pump(Duration) para avanzar el tiempo falso
// (pumpAndSettle no termina mientras gira el CircularProgressIndicator).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tres_estados/main.dart';
import 'package:lista_tres_estados/pantalla_pedidos.dart';
import 'package:lista_tres_estados/repositorio_falso.dart';

const _demora = Duration(seconds: 1);

Widget _app(RepositorioFalso repositorio) =>
    AppCafeteria(repositorio: repositorio);

void main() {
  // IA: alto suficiente para que ListView.builder construya las 6 tarjetas.
  setUp(() {
    final vista =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    vista.physicalSize = const Size(1080, 2400);
    vista.devicePixelRatio = 2.0;
  });

  tearDown(() {
    final vista =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    vista.resetPhysicalSize();
    vista.resetDevicePixelRatio();
  });

  testWidgets('empieza en Cargando con CircularProgressIndicator', (
    tester,
  ) async {
    await tester.pumpWidget(_app(RepositorioFalso(demora: _demora)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Card), findsNothing);
    expect(find.text('Reintentar'), findsNothing);

    // Deja terminar el Future pendiente antes de cerrar la prueba.
    await tester.pump(_demora);
  });

  testWidgets('la primera carga falla y muestra Error legible con Reintentar', (
    tester,
  ) async {
    await tester.pumpWidget(_app(RepositorioFalso(demora: _demora)));
    await tester.pump(_demora);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      find.text(
        'No pudimos cargar los pedidos. Revisa tu conexión e inténtalo de nuevo.',
      ),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
    // No se muestra el texto crudo de la excepción.
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('Sin conexión'), findsNothing);
  });

  testWidgets('Reintentar pasa por Cargando y llega a la lista de pedidos', (
    tester,
  ) async {
    await tester.pumpWidget(_app(RepositorioFalso(demora: _demora)));
    await tester.pump(_demora); // 1a llamada: error

    await tester.tap(find.text('Reintentar'));
    await tester.pump(); // procesa el setState de Cargando
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);

    await tester.pump(_demora); // 2a llamada: éxito
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(6));
    expect(find.text('Ana López'), findsOneWidget);
    expect(find.text('Latte · Tamaño M'), findsOneWidget);
    expect(find.text('Pendiente'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('si la carga funciona a la primera, muestra la lista', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(RepositorioFalso(demora: _demora, fallarPrimeraLlamada: false)),
    );
    await tester.pump(_demora);

    expect(find.byType(Card), findsNWidgets(6));
    expect(find.text('Carlos Méndez'), findsOneWidget);
    expect(find.text('Americano · Tamaño L'), findsOneWidget);
    expect(find.text('En preparación'), findsOneWidget);
  });

  testWidgets('mounted: cerrar la pantalla durante la carga no lanza error', (
    tester,
  ) async {
    await tester.pumpWidget(_app(RepositorioFalso(demora: _demora)));
    expect(find.byType(PantallaPedidos), findsOneWidget);

    // Se quita la pantalla antes de que termine el Future.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(_demora);

    // Gracias a `if (!mounted) return;` no se llama a setState en un State
    // desmontado.
    expect(tester.takeException(), isNull);
  });
}
