import 'package:flutter/material.dart';
import 'package:hospital/models/historial_model.dart';
import 'package:hospital/services/ficha_item_service.dart';
import 'package:hospital/services/historial_service.dart';
import 'package:hospital/widgets/fichaItem.dart';
import 'package:hospital/widgets/upcoming_schedule.dart'; // Importa tu modelo de Historial
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ScheduleScreen extends StatefulWidget {
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  final TextEditingController _ciController = TextEditingController();
  bool isLoading = false;
  List<dynamic> fichas = [];
  Historial? historial; // Variable para almacenar el historial

  final _scheduleWidgets = [
    UpcomingSchedule(),
    Center(child: Text("No hay citas completadas")),
    Center(child: Text("No hay citas canceladas")),
  ];

  // Función para cargar las fichas
  Future<void> fetchFichas() async {
    setState(() {
      isLoading = true;
    });
    try {
      final ci = int.parse(_ciController.text); // Obtenemos el CI ingresado
      var response = await FichaService().getFichasByPacienteId(ci); // Llamada al servicio
      setState(() {
        fichas = response['fichaList']; // Guardamos las fichas en la lista
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error al cargar las fichas: $e");
    }
  }

  Future<void> fetchHistorial() async {
    setState(() {
      isLoading = true;
    });
    try {
      final ci = int.parse(_ciController.text); // Obtenemos el CI ingresado
      var response = await HistorialService().getHistorialById(ci); // Llamada al servicio para obtener el historial

      // Verifica que la respuesta contenga el campo 'historail' y luego las 'consultas'
      if (response != null && response.containsKey('historail') && response['historail']['consultas'] != null) {
        setState(() {
          historial = Historial.fromJson(response['historail']); // Convertimos la respuesta en un objeto Historial
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Error: No se encontraron consultas en la respuesta.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error al cargar el historial: $e");
    }
  }

  // Función para generar y guardar un PDF
  Future<void> generatePdf(Historial historial) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('Historial Médico de Paciente ID: ${historial.idPaciente}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ...historial.consultas.map((consulta) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Consulta ID: ${consulta.id}', style: pw.TextStyle(fontSize: 18)),
                  pw.Text('Fecha: ${consulta.fecha}'),
                  pw.Text('Diagnóstico: ${consulta.diagnostico}'),
                  pw.SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/historial_medico.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF guardado en ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Fichas",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Barra de pestañas
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton("Horario", 0),
                  _buildTabButton("Ficha", 1),
                  _buildTabButton("Historial", 2),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Sección de Ficha
            _buttonIndex == 1
                ? _buildFichaSection()
                : _buttonIndex == 2
                ? _buildHistorialSection() // Sección para mostrar el historial
                : _scheduleWidgets[_buttonIndex], // Muestra el horario en la pestaña 0
          ],
        ),
      ),
    );
  }

  Widget _buildFichaSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _ciController,
            decoration: InputDecoration(
              labelText: 'Ingrese su número de carnet',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
            onPressed: fetchFichas,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7165D6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            ),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              "Mostrar Fichas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : fichas.isEmpty
            ? Center(child: Text("No se encontraron fichas"))
            : Column(
          children: fichas.map<Widget>((ficha) {
            return FichaItem(ficha: ficha); // Widget para mostrar cada ficha
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHistorialSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _ciController,
            decoration: InputDecoration(
              labelText: 'Ingrese su número de carnet',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
            onPressed: fetchHistorial,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7165D6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            ),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              "Mostrar Historial",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        if (historial != null && historial!.consultas.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historial Médico:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...historial!.consultas.map((consulta) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consulta ID: ${consulta.id}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Fecha: ${consulta.fecha}'),
                        SizedBox(height: 5),
                        Text('Diagnóstico: ${consulta.diagnostico}'),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => generatePdf(historial!),
                  child: Text('Generar PDF'),
                ),
              ],
            ),
          )
        else if (!isLoading)
          Center(child: Text("No se encontró historial")),
      ],
    );
  }

  Widget _buildTabButton(String text, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _buttonIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        decoration: BoxDecoration(
          color: _buttonIndex == index ? Color(0xFF7165D6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _buttonIndex == index ? Colors.white : Colors.black38,
          ),
        ),
      ),
    );
  }
}