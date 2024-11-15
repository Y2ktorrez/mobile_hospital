import 'package:flutter/material.dart';
import 'package:hospital/models/ficha_model.dart';
import 'package:hospital/services/ficha_service.dart';

class CreateFichaScreen extends StatefulWidget {
  @override
  _CreateFichaScreenState createState() => _CreateFichaScreenState();
}

class _CreateFichaScreenState extends State<CreateFichaScreen> {
  final _formKey = GlobalKey<FormState>();
  final FichaService _fichaService = FichaService();

  DateTime? fechaEmision;
  DateTime? fechaAtencion;
  String? horaAtencion;
  int? ciPaciente;
  int? ciMedico;
  int? idEspecialidad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Ficha"),
        backgroundColor: Color(0xFF7165D6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "CI Paciente",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el CI del paciente';
                  }
                  return null;
                },
                onSaved: (value) {
                  ciPaciente = int.tryParse(value!);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "CI Médico",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el CI del médico';
                  }
                  return null;
                },
                onSaved: (value) {
                  ciMedico = int.tryParse(value!);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "ID Especialidad",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el ID de la especialidad';
                  }
                  return null;
                },
                onSaved: (value) {
                  idEspecialidad = int.tryParse(value!);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Fecha de Emisión (YYYY-MM-DD)",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de emisión';
                  }
                  return null;
                },
                onSaved: (value) {
                  fechaEmision = DateTime.tryParse(value!);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Fecha de Atención (YYYY-MM-DD)",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de atención';
                  }
                  return null;
                },
                onSaved: (value) {
                  fechaAtencion = DateTime.tryParse(value!);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Hora de Atención (HH:mm)",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la hora de atención';
                  }
                  return null;
                },
                onSaved: (value) {
                  horaAtencion = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _createFicha();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7165D6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                ),
                child: Text(
                  "Crear Ficha",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createFicha() async {
    if (fechaEmision != null &&
        fechaAtencion != null &&
        horaAtencion != null &&
        ciPaciente != null &&
        ciMedico != null &&
        idEspecialidad != null) {
      FichaDto fichaDto = FichaDto(
        fechaEmision: fechaEmision!,
        fechaAtencion: fechaAtencion!,
        horaAtencion: horaAtencion!,
        ciPaciente: ciPaciente!,
        ciMedico: ciMedico!,
        idEspecialidad: idEspecialidad!,
      );

      try {
        await _fichaService.createFicha(fichaDto);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ficha creada exitosamente")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al crear la ficha: $e")));
      }
    }
  }
}
