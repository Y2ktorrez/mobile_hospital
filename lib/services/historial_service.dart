import 'dart:convert';
import 'package:http/http.dart' as http;

class HistorialService {
  // Definir la URL completa, incluyendo el parámetro del id
  final String baseUrl = 'http://192.168.0.15:2424/consulta/historial/';

  Future<Map<String, dynamic>> getHistorialById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl$id'));

    // Imprimir la respuesta cruda
    print("Respuesta de la API: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el historial: ${response.reasonPhrase}');
    }
  }

}
