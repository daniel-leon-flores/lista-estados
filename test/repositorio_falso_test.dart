// IA: pruebas unitarias del repositorio falso generadas con Claude (Anthropic).
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tres_estados/repositorio_falso.dart';

void main() {
  test(
    'la primera llamada falla y la segunda devuelve al menos 5 pedidos',
    () async {
      final repositorio = RepositorioFalso(demora: Duration.zero);

      await expectLater(repositorio.obtener(), throwsException);

      final pedidos = await repositorio.obtener();
      expect(pedidos.length, greaterThanOrEqualTo(5));
    },
  );

  test('la demora por defecto está entre 1 y 2 segundos', () {
    final demora = RepositorioFalso().demora;
    expect(demora, greaterThanOrEqualTo(const Duration(seconds: 1)));
    expect(demora, lessThanOrEqualTo(const Duration(seconds: 2)));
  });
}
