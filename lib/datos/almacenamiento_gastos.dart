import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/gasto.dart';

class AlmacenamientoGastos {
  final String _clave = 'gastos';

  // Guardar una lista de gastos.
  Future<void> guardarGastos(List<Gasto> gastos) async {
    final prefs = await SharedPreferences.getInstance();
    final datosCodificados = jsonEncode(gastos.map((g) => g.toMap()).toList());
    prefs.setString(_clave, datosCodificados);
  }

  // Recuperar la lista de gastos guardados.
  Future<List<Gasto>> cargarGastos() async {
    final prefs = await SharedPreferences.getInstance();
    final datosGuardados = prefs.getString(_clave);
    if (datosGuardados == null) return [];
    final datosDecodificados = jsonDecode(datosGuardados) as List;
    return datosDecodificados.map((g) => Gasto.fromMap(g)).toList();
  }
}
