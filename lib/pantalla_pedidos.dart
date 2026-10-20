import 'package:flutter/material.dart';

import 'pedido.dart';
import 'repositorio_falso.dart';
import 'resultado.dart';

// IA: pantalla generada con Claude (Anthropic); revisada y probada por el
// alumno. Solo usa StatefulWidget + setState (sin Provider, Bloc ni Riverpod).
class PantallaPedidos extends StatefulWidget {
  const PantallaPedidos({super.key, required this.repositorio});

  // El repositorio se recibe por constructor para poder cambiarlo en pruebas.
  final RepositorioFalso repositorio;

  @override
  State<PantallaPedidos> createState() => _PantallaPedidosState();
}

class _PantallaPedidosState extends State<PantallaPedidos> {
  // IA: estado de la pantalla; empieza en Cargando.
  Resultado<List<Pedido>> _estado = const Cargando();

  // IA: initState se ejecuta una sola vez al crear el State; ahí arranca la
  // primera carga (sin await, porque initState no puede ser async).
  @override
  void initState() {
    super.initState();
    _cargar();
  }

  // IA: pide los datos y guarda el resultado con setState.
  Future<void> _cargar() async {
    try {
      final pedidos = await widget.repositorio.obtener();
      // Durante el await la pantalla pudo cerrarse. Si ya no está montada,
      // llamar a setState lanzaría un error, así que salimos.
      if (!mounted) return;
      // setState cambia el estado y marca el widget como "sucio": Flutter
      // vuelve a llamar a build() y la pantalla se pinta con el nuevo estado.
      setState(() => _estado = Exito(pedidos));
    } catch (_) {
      if (!mounted) return;
      // Mensaje legible en español; no se muestra la excepción ni el stack.
      setState(
        () => _estado = const Error(
          'No pudimos cargar los pedidos. Revisa tu conexión e inténtalo de nuevo.',
        ),
      );
    }
  }

  // IA: el botón Reintentar regresa a Cargando (se ve el indicador) y vuelve
  // a pedir los datos.
  void _reintentar() {
    setState(() => _estado = const Cargando());
    _cargar();
  }

  // IA: build se llama cada vez que setState marca la pantalla como sucia.
  // El switch es exhaustivo porque Resultado es sealed: no lleva default.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos de la cafetería')),
      body: switch (_estado) {
        Cargando() => const Center(child: CircularProgressIndicator()),
        Exito(:final datos) => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: datos.length,
          itemBuilder: (context, indice) =>
              _TarjetaPedido(pedido: datos[indice]),
        ),
        Error(:final mensaje) => _VistaError(
          mensaje: mensaje,
          alReintentar: _reintentar,
        ),
      },
    );
  }
}

// IA: tarjeta con los datos de un pedido (cliente, bebida/tamaño y estado).
class _TarjetaPedido extends StatelessWidget {
  const _TarjetaPedido({required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.local_cafe)),
        title: Text(pedido.cliente),
        subtitle: Text(
          '${pedido.bebida.etiqueta} · Tamaño ${pedido.tamano.etiqueta}',
        ),
        trailing: Text(pedido.estado.etiqueta),
      ),
    );
  }
}

// IA: vista del estado de error con el mensaje y el botón Reintentar.
class _VistaError extends StatelessWidget {
  const _VistaError({required this.mensaje, required this.alReintentar});

  final String mensaje;
  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
