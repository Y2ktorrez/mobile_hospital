import 'dart:convert';
import 'package:hospital/models/ficha_model.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class FichaService {
  final String baseUrl = 'http://192.168.0.15:2424/ficha/create';
  final AuthService authService = AuthService();

  Future<void> createFicha(FichaDto fichaDto) async {
    final token = await authService.getToken();
    if (token == null) {
      // Redirigir a la pantalla de login si no hay token
      throw Exception("No se encontró el token. El usuario no está autenticado.");
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(fichaDto.toJson()), // Aquí se convierte el objeto FichaDto a JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Ficha creada exitosamente');
    } else if (response.statusCode == 401) {
      throw Exception('Token expirado o inválido');
    } else {
      throw Exception('Error al crear la ficha: ${response.body}');
    }
  }
}