import 'dart:convert';
import 'package:http/http.dart' as http;

class HorarioMedicoService {
  //final String baseUrl = 'http://ec2-18-118-8-106.us-east-2.compute.amazonaws.com/horario_medico/getAll';
  final String baseUrl = 'http://192.168.0.15:2424/horario_medico/getAll';

  Future<List<dynamic>> getAllHorariosMedicos() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['horarioMedicoList'] ?? [];
    } else {
      throw Exception('Error al obtener la lista de horarios médicos');
    }
  }
}

