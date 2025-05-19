import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../modelos/gasto.dart';

class PantallaAgregarGasto extends StatefulWidget {
  final Gasto? gastoExistente;

  const PantallaAgregarGasto({super.key, this.gastoExistente});

  @override
  PantallaAgregarGastoState createState() => PantallaAgregarGastoState();
}

class PantallaAgregarGastoState extends State<PantallaAgregarGasto> {
  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorCantidad = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.gastoExistente != null) {
      _controladorTitulo.text = widget.gastoExistente!.titulo;
      _controladorCantidad.text = widget.gastoExistente!.cantidad.toString();
    }
  }

  void _guardarGasto() {
    final titulo = _controladorTitulo.text;
    final cantidad = double.tryParse(_controladorCantidad.text) ?? 0;

    if (titulo.isEmpty || cantidad <= 0) {
      _mostrarAlerta('Ingrese un título y una cantidad válida.');
      return;
    }

    final nuevoGasto = Gasto(
      id: widget.gastoExistente?.id ?? const Uuid().v4(),
      titulo: titulo,
      cantidad: cantidad,
    );

    Navigator.pop(context, nuevoGasto);
  }

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Datos inválidos'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gastoExistente == null ? 'Agregar Gasto' : 'Editar Gasto',
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controladorTitulo,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controladorCantidad,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _guardarGasto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 50,
                ),
              ),
              child: const Text(
                'Guardar Gasto',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
