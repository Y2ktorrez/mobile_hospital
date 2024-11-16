import 'package:flutter/material.dart';
import 'package:hospital/widgets/upcoming_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;

  final _scheduleWidgets = [
    UpcomingSchedule(),
    Center(child: Text("No hay citas completadas")),
    Center(child: Text("No hay citas canceladas")),
  ];

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
                  _buildTabButton("Pago", 2),
                ],
              ),
            ),
            SizedBox(height: 30),
            _scheduleWidgets[_buttonIndex],
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