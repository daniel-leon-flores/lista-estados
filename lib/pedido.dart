// Entidad del caso de estudio del curso (gestor de cafetería).
// Si la entidad del proyecto real del equipo es distinta, se cambia aquí.

// IA: enums generados con Claude (Anthropic); cada valor guarda su etiqueta
// en español para mostrarla en la interfaz.
enum Bebida {
  espresso('Espresso'),
  americano('Americano'),
  latte('Latte'),
  cappuccino('Cappuccino'),
  mocha('Mocha');

  const Bebida(this.etiqueta);

  final String etiqueta;
}

// IA: tamaños disponibles (S, M, L).
enum Tamano {
  s('S'),
  m('M'),
  l('L');

  const Tamano(this.etiqueta);

  final String etiqueta;
}

// IA: estados por los que pasa un pedido en la cafetería.
enum EstadoPedido {
  pendiente('Pendiente'),
  enPreparacion('En preparación'),
  listo('Listo'),
  entregado('Entregado'),
  cancelado('Cancelado');

  const EstadoPedido(this.etiqueta);

  final String etiqueta;
}

// IA: entidad inmutable: todos los campos son `final` y el constructor es
// `const` con parámetros con nombre obligatorios.
class Pedido {
  const Pedido({
    required this.id,
    required this.cliente,
    required this.bebida,
    required this.tamano,
    required this.estado,
  });

  final int id;
  final String cliente;
  final Bebida bebida;
  final Tamano tamano;
  final EstadoPedido estado;
}
