import 'package:hospital/models/historial_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

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

  final output = File('historial_medico.pdf');
  await output.writeAsBytes(await pdf.save());
}
