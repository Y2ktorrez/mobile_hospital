import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MedicoService {
  final String baseUrl = 'http://192.168.0.15:2424/medico/getAll';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<dynamic>> getAllMedicos() async {
    final token = await _storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['medicoList'];
    } else {
      throw Exception('Error al obtener la lista de médicos');
    }
  }
}