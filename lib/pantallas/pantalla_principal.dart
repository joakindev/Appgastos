import 'package:flutter/material.dart';
import '../datos/almacenamiento_gastos.dart';
import '../modelos/gasto.dart';
import 'pantalla_agregar_gasto.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  PantallaPrincipalState createState() => PantallaPrincipalState();
}

class PantallaPrincipalState extends State<PantallaPrincipal> {
  final AlmacenamientoGastos _almacenamientoGastos = AlmacenamientoGastos();
  List<Gasto> _gastos = [];

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  void _cargarGastos() async {
    final gastos = await _almacenamientoGastos.cargarGastos();
    setState(() {
      _gastos = gastos;
    });
  }

  void eliminarGasto(String id) {
    setState(() {
      _gastos.removeWhere((gasto) => gasto.id == id);
    });
    _almacenamientoGastos.guardarGastos(_gastos);
  }

  void _editarGasto(Gasto gastoEditado) {
    setState(() {
      final index = _gastos.indexWhere((g) => g.id == gastoEditado.id);
      if (index != -1) {
        _gastos[index] = gastoEditado;
      }
    });
    _almacenamientoGastos.guardarGastos(_gastos);
  }

  @override
  Widget build(BuildContext context) {
    final total = _gastos.fold(0.0, (suma, item) => suma + item.cantidad);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Gestión de Gastos',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepOrange,
    ),
    body: Column(
        children: [
          // Tarjeta del total con diseño
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total de Gastos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),


          // Lista de gastos
          Expanded(
            child: _gastos.isEmpty
                ? const Center(
              child: Text(
                'No has ingresado gastos. ¡Agrega uno!',
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            )
                : ListView.builder(
              itemCount: _gastos.length,
              itemBuilder: (context, indice) {
                final gasto = _gastos[indice];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\$${gasto.cantidad.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      gasto.titulo,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            final gastoEditado = await Navigator.push<Gasto>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PantallaAgregarGasto(
                                      gastoExistente: gasto,
                                    ),
                              ),
                            );
                            if (gastoEditado != null) {
                              _editarGasto(gastoEditado);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _mostrarDialogoEliminar(gasto.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () async {
          final nuevoGasto = await Navigator.push<Gasto>(
            context,
            MaterialPageRoute(
              builder: (_) => const PantallaAgregarGasto(),
            ),
          );
          if (nuevoGasto != null) {
            setState(() => _gastos.add(nuevoGasto));
            _almacenamientoGastos.guardarGastos(_gastos);
          }
        },
      ),
    );
  }

  void _mostrarDialogoEliminar(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Gasto'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este gasto?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _eliminarGasto(id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _eliminarGasto(String id) {
    setState(() {
      _gastos.removeWhere((gasto) => gasto.id == id);
    });
    _almacenamientoGastos.guardarGastos(_gastos);
  }
}