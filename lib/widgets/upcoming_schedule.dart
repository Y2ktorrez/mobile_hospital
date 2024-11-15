import 'package:flutter/material.dart';
import 'package:hospital/screens/ficha_screen.dart';
import 'package:hospital/services/horario_medico_service.dart';

class UpcomingSchedule extends StatefulWidget {
  @override
  _UpcomingScheduleState createState() => _UpcomingScheduleState();
}

class _UpcomingScheduleState extends State<UpcomingSchedule> {
  final HorarioMedicoService _horarioMedicoService = HorarioMedicoService();
  List<dynamic> horariosMedicos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHorariosMedicos();
  }

  Future<void> _loadHorariosMedicos() async {
    try {
      List<dynamic> horarioList = await _horarioMedicoService.getAllHorariosMedicos();
      setState(() {
        horariosMedicos = horarioList;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar los horarios médicos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (horariosMedicos.isEmpty) {
      return Center(child: Text("No hay horarios disponibles"));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: horariosMedicos.expand<Widget>((horarioMedico) {
          final nombreMedico = horarioMedico['nombreMedico'] ?? "Doctor";
          final especialidad = horarioMedico['nombreEspecialidad'] ?? "Especialidad";
          final horarios = horarioMedico['horarios'] as List<dynamic>;

          return horarios.map<Widget>((horario) {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
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
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person, color: Colors.white),
                      backgroundColor: Colors.grey[400],
                    ),
                    title: Text(
                      nombreMedico,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(especialidad),
                  ),
                  Divider(thickness: 1, height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black54, size: 18),
                            SizedBox(width: 5),
                            Text(
                              horario['dia'],
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.black54, size: 18),
                            SizedBox(width: 5),
                            Text(
                              "${horario['horaInicio']} - ${horario['horaFin']}",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Disponible",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateFichaScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7165D6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      ),
                      child: Text(
                        "Agregar Ficha",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        }).toList(),
      ),
    );
  }
}
