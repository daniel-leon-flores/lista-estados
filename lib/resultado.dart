// IA: clase sellada generada con Claude (Anthropic) a partir del Resultado<T>
// de la T1 de nivelación; revisada y probada por el alumno.
//
// Resultado<T> representa los tres estados posibles de una carga de datos.
// Como es `sealed`, todas sus subclases están en este archivo y el compilador
// las conoce: un switch que cubra Cargando, Exito y Error es exhaustivo y no
// necesita `default`.
sealed class Resultado<T> {
  const Resultado();
}

// IA: estado inicial mientras se espera la respuesta del repositorio.
final class Cargando<T> extends Resultado<T> {
  const Cargando();
}

// IA: la carga terminó bien; `datos` trae la información obtenida.
final class Exito<T> extends Resultado<T> {
  const Exito(this.datos);

  final T datos;
}

// IA: la carga falló; `mensaje` es un texto legible para la persona usuaria
// (nunca el texto de la excepción ni el stack trace).
final class Error<T> extends Resultado<T> {
  const Error(this.mensaje);

  final String mensaje;
}
