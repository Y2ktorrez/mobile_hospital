import 'package:flutter/material.dart';
import 'package:hospital/services/ficha_item_service.dart';
import 'package:hospital/widgets/fichaItem.dart';
import 'package:hospital/widgets/upcoming_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  final TextEditingController _ciController = TextEditingController();
  bool isLoading = false;
  List<dynamic> fichas = [];

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
      var response = await FichaService().getFichasByPacienteId(ci); // Suponiendo que tienes el servicio FichaService
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

            // Solo mostramos el campo de CI y el botón en la pestaña "Ficha"
            _buttonIndex == 1
                ? Column(
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
            )
                : _scheduleWidgets[_buttonIndex], // Muestra el horario en la pestaña 0
          ],
        ),
      ),
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