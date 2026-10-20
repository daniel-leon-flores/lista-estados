import 'pedido.dart';

// IA: repositorio falso generado con Claude (Anthropic) a partir del esqueleto
// de la tarea. Simula una fuente de datos lenta (1.5 s por defecto, dentro del
// rango de 1 a 2 s) que falla en la primera llamada y funciona en la segunda,
// para poder probar el estado de error y el botón Reintentar.
class RepositorioFalso {
  RepositorioFalso({
    this.demora = const Duration(milliseconds: 1500),
    this.fallarPrimeraLlamada = true,
  });

  // Se pueden cambiar desde las pruebas (inyección por constructor).
  final Duration demora;
  final bool fallarPrimeraLlamada;

  int _llamadas = 0;

  // IA: datos de ejemplo ficticios del caso de estudio (cafetería).
  static const List<Pedido> _pedidos = [
    Pedido(
      id: 101,
      cliente: 'Ana López',
      bebida: Bebida.latte,
      tamano: Tamano.m,
      estado: EstadoPedido.pendiente,
    ),
    Pedido(
      id: 102,
      cliente: 'Carlos Méndez',
      bebida: Bebida.americano,
      tamano: Tamano.l,
      estado: EstadoPedido.enPreparacion,
    ),
    Pedido(
      id: 103,
      cliente: 'Sofía Ramírez',
      bebida: Bebida.cappuccino,
      tamano: Tamano.s,
      estado: EstadoPedido.listo,
    ),
    Pedido(
      id: 104,
      cliente: 'Diego Torres',
      bebida: Bebida.mocha,
      tamano: Tamano.m,
      estado: EstadoPedido.entregado,
    ),
    Pedido(
      id: 105,
      cliente: 'Valeria Ruiz',
      bebida: Bebida.espresso,
      tamano: Tamano.s,
      estado: EstadoPedido.cancelado,
    ),
    Pedido(
      id: 106,
      cliente: 'Luis Hernández',
      bebida: Bebida.latte,
      tamano: Tamano.l,
      estado: EstadoPedido.pendiente,
    ),
  ];

  // IA: espera `demora`, cuenta la llamada y lanza una excepción solo la
  // primera vez (si `fallarPrimeraLlamada` es true).
  Future<List<Pedido>> obtener() async {
    await Future.delayed(demora);
    _llamadas++;
    if (fallarPrimeraLlamada && _llamadas == 1) {
      throw Exception('Sin conexión'); // falla la 1a vez
    }
    return _pedidos;
  }
}
