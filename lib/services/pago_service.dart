import 'dart:convert';
import 'package:hospital/models/pago_model.dart';
import 'package:http/http.dart' as http;

class PagoService {
  final String baseUrl = 'http://192.168.0.15:2424/pago';

  Future<PagoDto> calcularPagoTotal(int idConsulta) async {
    final response = await http.get(Uri.parse('$baseUrl/calcular/$idConsulta'));

    if (response.statusCode == 200) {
      return PagoDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to calculate total payment');
    }
  }

  Future<PagoDto> realizarPago(int idConsulta, String tipoPago) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pagar/$idConsulta'),
      body: {'tipoPago': tipoPago},
    );

    if (response.statusCode == 200) {
      return PagoDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to process payment');
    }
  }
}