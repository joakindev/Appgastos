class Gasto {
  String id;
  String titulo;
  double cantidad;

  Gasto({
    required this.id,
    required this.titulo,
    required this.cantidad,
  });

  // Para convertir el gasto en un mapa (útil para almacenamiento).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'cantidad': cantidad,
    };
  }

  // Para reconvertir un mapa en un objeto Gasto.
  factory Gasto.fromMap(Map<String, dynamic> mapa) {
    return Gasto(
      id: mapa['id'],
      titulo: mapa['titulo'],
      cantidad: mapa['cantidad'],
    );
  }
}
