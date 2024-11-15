import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = FlutterSecureStorage();
  final String baseUrl = 'http://192.168.0.15:2424/login/paciente';
  //final String baseUrl = 'http://ec2-18-118-8-106.us-east-2.compute.amazonaws.com/login/paciente';

  Future<String?> login(String email, String password) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'auth_token', value: data['token']);
        return null; // Login exitoso
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Error del servidor';
        print("Error de login: $errorMessage");
        return errorMessage;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return 'Error de conexión';
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Función genérica para extraer datos del token
  Future<String?> getDataFromToken(String key) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return null;

    final parts = token.split('.');
    if (parts.length != 3) {
      print("Token no es un JWT válido.");
      return null;
    }

    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );

    return payload[key];
  }

  Future<String?> getUserNameFromToken() async {
    return await getDataFromToken('nombre');
  }

  Future<String?> getUserCarnetFromToken() async {
    return await getDataFromToken('ci');
  }
}