import 'package:flutter/material.dart';

class FichaItem extends StatelessWidget {
  final dynamic ficha;

  FichaItem({required this.ficha});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        title: Text("Paciente: ${ficha['nombrePaciente']}"),
        subtitle: Text("Fecha de atención: ${ficha['fechaAtencion']}"),
        trailing: Text(ficha['horaAtencion']),
        onTap: () {
          // Aquí puedes agregar lógica si deseas mostrar más detalles de la ficha
        },
      ),
    );
  }
}
