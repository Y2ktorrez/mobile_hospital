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
          pw.SizedBox(height: 10),
          ...historial.consultas.map((consulta) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Consulta ID: ${consulta.id}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Fecha: ${consulta.fecha}'),
                pw.Text('Diagnóstico: ${consulta.diagnostico}'),
                pw.SizedBox(height: 10),

                pw.Text('Preconsulta:'),
                pw.Text('Estado: ${consulta.preconsulta.estado}'),
                pw.Text('Enfermero: ${consulta.preconsulta.enfermero.name}'),
                pw.Text('Preconsulta Terminada: ${consulta.preconsulta.preconsultaTerminada}'),
                pw.SizedBox(height: 10),

                pw.Text('Ficha:'),
                pw.Text('Fecha de Emisión: ${consulta.ficha.fechaEmision}'),
                pw.Text('Fecha de Atención: ${consulta.ficha.fechaAtencion}'),
                pw.Text('Hora de Atención: ${consulta.ficha.horaAtencion}'),
                pw.Text('Paciente: ${consulta.ficha.nombrePaciente}'),
                pw.Text('Médico: ${consulta.ficha.nombreMedico}'),
                pw.Text('Especialidad: ${consulta.ficha.nombreEspecialidad}'),
                pw.SizedBox(height: 10),

                pw.Text('Exámenes:'),
                ...consulta.examenes.map((examen) {
                  return pw.Text('Examen ID: ${examen.id}, Resultado: ${examen.resultado}, Fecha: ${examen.fecha}');
                }).toList(),

                pw.SizedBox(height: 10),

                pw.Text('Análisis:'),
                ...consulta.analisis.map((analisis) {
                  return pw.Text('Análisis ID: ${analisis.id}, Resultado: ${analisis.resultado}, Fecha: ${analisis.fecha}');
                }).toList(),

                pw.SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      ),
    ),
  );

  final output = File('historial_completo_medico.pdf');
  await output.writeAsBytes(await pdf.save());
}

