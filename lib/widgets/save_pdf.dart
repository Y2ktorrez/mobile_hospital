import 'package:flutter/material.dart';
import 'package:hospital/models/historial_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, rootBundle;

Future<void> savePdfToDownloads(BuildContext context, Historial historial) async {
  final directory = await getExternalStorageDirectory();
  final downloadDirectory = Directory('${directory!.path}/Download');

  if (!await downloadDirectory.exists()) {
    await downloadDirectory.create(recursive: true); // Crea la carpeta si no existe
  }

  final file = File('${downloadDirectory.path}/historial_medico.pdf');

  final pdf = pw.Document();

  final regularFont = await pdfFontFromAsset('assets/fonts/Roboto-Regular.ttf');
  final boldFont = await pdfFontFromAsset('assets/fonts/Roboto-Bold.ttf');

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          children: [
            pw.Text(
              'Historial Médico de Paciente ID: ${historial.idPaciente}',
              style: pw.TextStyle(font: boldFont, fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            ...historial.consultas.map((consulta) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Consulta ID: ${consulta.id}', style: pw.TextStyle(font: boldFont, fontSize: 18)),
                  pw.Text('Fecha: ${consulta.fecha}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Diagnóstico: ${consulta.diagnostico}', style: pw.TextStyle(font: regularFont)),
                  pw.SizedBox(height: 10),

                  pw.Text('Preconsulta:', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                  pw.Text('Estado: ${consulta.preconsulta.estado}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Preconsulta Terminada: ${consulta.preconsulta.preconsultaTerminada}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Enfermero: ${consulta.preconsulta.enfermero.name}, CI: ${consulta.preconsulta.enfermero.ci}, Email: ${consulta.preconsulta.enfermero.email}', style: pw.TextStyle(font: regularFont)),
                  pw.SizedBox(height: 10),

                  pw.Text('Ficha:', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                  pw.Text('Fecha de Emisión: ${consulta.ficha.fechaEmision}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Fecha de Atención: ${consulta.ficha.fechaAtencion}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Hora de Atención: ${consulta.ficha.horaAtencion}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Paciente: ${consulta.ficha.nombrePaciente}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Médico: ${consulta.ficha.nombreMedico}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Especialidad: ${consulta.ficha.nombreEspecialidad}', style: pw.TextStyle(font: regularFont)),
                  pw.Text('Ficha Terminada: ${consulta.ficha.fichaTerminada}', style: pw.TextStyle(font: regularFont)),
                  pw.SizedBox(height: 10),

                  pw.Text('Exámenes:', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                  ...consulta.examenes.map((examen) {
                    return pw.Text('Examen ID: ${examen.id}, Resultado: ${examen.resultado}, Fecha: ${examen.fecha}', style: pw.TextStyle(font: regularFont));
                  }).toList(),
                  pw.SizedBox(height: 10),

                  pw.Text('Análisis:', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                  ...consulta.analisis.map((analisis) {
                    return pw.Text('Análisis ID: ${analisis.id}, Resultado: ${analisis.resultado}, Fecha: ${analisis.fecha}', style: pw.TextStyle(font: regularFont));
                  }).toList(),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
          ],
        );
      },
    ),
  );

  await file.writeAsBytes(await pdf.save());

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('PDF guardado en ${file.path}')),
  );
}

Future<pw.Font> pdfFontFromAsset(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final fontData = byteData.buffer.asUint8List(); // Convertimos el ByteData a Uint8List
  final byteDataConverted = ByteData.sublistView(fontData); // Convertimos el Uint8List a ByteData
  return pw.Font.ttf(byteDataConverted); // Usamos el ByteData convertido en pw.Font.ttf()
}
