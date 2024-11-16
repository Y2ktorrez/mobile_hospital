import 'package:http/http.dart' as http;
import 'dart:convert';

class FichaService {
  Future<Map<String, dynamic>> getFichasByPacienteId(int ci) async {
    final response = await http.get(Uri.parse('http://192.168.0.15:2424/ficha/getByCi/$ci'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve el cuerpo de la respuesta como un Map
    } else {
      throw Exception('Error al cargar las fichas');
    }
  }
}
