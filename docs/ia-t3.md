# Declaración de uso de IA · Tarea 3 de nivelación

**Nivel de la política:** Nivel 2, IA como herramienta declarada.

## Herramienta

- Claude (Anthropic).

Los bloques de código que generó la herramienta están marcados con el comentario `// IA:` en
`lib/` y `test/`.

## Prompts principales

[Completa aquí los prompts reales que usaste, por ejemplo:
1. "…"
2. "…"]

## Qué acepté

[Describe qué partes del código generado aceptaste tal cual y por qué las entiendes; por ejemplo,
la clase sellada `Resultado`, el `switch` exhaustivo, el uso de `mounted`…]

## Qué cambié o rechacé

[Describe qué modificaste o rechazaste: nombres, datos de ejemplo, la entidad de tu proyecto real,
textos, estilos, pruebas que quitaste o agregaste…]

## Cómo lo probé

Pruebas que se ejecutaron realmente sobre este código:

1. **Análisis estático:** `flutter analyze` → `No issues found!`
2. **Pruebas automáticas:** `flutter test` → 7 pruebas en verde:
   - `test/repositorio_falso_test.dart`: la primera llamada lanza excepción y la segunda devuelve
     ≥ 5 pedidos; la demora por defecto está entre 1 y 2 s.
   - `test/pantalla_pedidos_test.dart` (widget tests con `tester.pump(Duration)`):
     - empieza en Cargando con `CircularProgressIndicator`;
     - la primera carga muestra el mensaje de error legible y el botón **Reintentar**, sin el
       texto de la excepción;
     - **Reintentar** pasa por Cargando y llega a la lista con 6 tarjetas;
     - si el repositorio no falla, se muestra la lista directamente;
     - cerrar la pantalla durante la carga no lanza error (`if (!mounted) return;`). Se comprobó
       que, al quitar temporalmente esa línea, esta prueba falla con
       `setState() called after dispose()`.
3. **Prueba manual de los tres estados (web):** se compiló la app con `flutter build web`, se abrió
   en Chrome (modo headless, ventana de 412 × 915) y se tomaron capturas del flujo real: cargando →
   error → clic en **Reintentar** → cargando → lista. Las capturas están en `docs/evidencia/`.

[Agrega aquí tus propias pruebas en tu dispositivo o emulador, si las hiciste.]
