import 'package:flutter/material.dart';
import 'package:hospital/services/pago_service.dart';
import 'package:hospital/models/pago_model.dart';

class SettingScreen1 extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen1> {
  final TextEditingController idConsultaController = TextEditingController();
  final TextEditingController tipoPagoController = TextEditingController();

  // Estado de carga
  bool isLoading = false;
  PagoDto? pagoDto;

  // Opciones para el Dropdown
  List<String> tipoPagoOptions = ['Efectivo', 'Tarjeta', 'Qr', 'Stripe'];
  String selectedTipoPago = 'Efectivo'; // Valor por defecto

  // Método para calcular el pago total
  Future<void> calcularPago() async {
    setState(() {
      isLoading = true;
    });

    try {
      final idConsulta = int.parse(idConsultaController.text);
      final pago = await PagoService().calcularPagoTotal(idConsulta);
      setState(() {
        pagoDto = pago;
      });
    } catch (e) {
      setState(() {
        pagoDto = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al calcular el pago: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para realizar el pago
  Future<void> realizarPago() async {
    setState(() {
      isLoading = true;
    });

    try {
      final idConsulta = int.parse(idConsultaController.text);
      final tipoPago = selectedTipoPago; // Utilizamos el valor seleccionado
      final pago = await PagoService().realizarPago(idConsulta, tipoPago);
      setState(() {
        pagoDto = pago;
      });

      // Mostrar el AlertDialog con el ícono de éxito
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        pagoDto = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al realizar el pago: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para mostrar el diálogo de éxito
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          content: Text('Pago realizado con éxito!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Pagos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección para calcular el pago total
            TextField(
              controller: idConsultaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID de la Consulta',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : calcularPago,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Calcular Total de Pago'),
            ),
            if (pagoDto != null && pagoDto?.costoTotal != null)
              Text('Costo Total: \$${pagoDto!.costoTotal}'),
            SizedBox(height: 16),

            // Separador
            Divider(),
            SizedBox(height: 16),

            // Sección para seleccionar tipo de pago
            DropdownButton<String>(
              value: selectedTipoPago,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTipoPago = newValue!;
                });
              },
              items: tipoPagoOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Sección para realizar el pago
            ElevatedButton(
              onPressed: isLoading ? null : realizarPago,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Realizar Pago'),
            ),
            if (pagoDto != null)
              Text(
                pagoDto!.cancelado ? 'Pago Cancelado' : 'Pago Exitoso',
                style: TextStyle(
                  color: pagoDto!.cancelado ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
