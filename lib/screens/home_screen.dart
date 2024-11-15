import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hospital/screens/appointment_screen.dart';
import 'package:hospital/services/auth_service.dart';
import 'package:hospital/services/especialidad_service.dart';
import 'package:hospital/services/medico_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final MedicoService _medicoService = MedicoService();
  final EspecialidadService _especialidadService = EspecialidadService();
  String userName = "User";
  final AuthService _authService = AuthService();

  List<dynamic> doctors = [];
  List<dynamic> especialidades = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadDoctors();
    _loadEspecialidades();
  }

  Future<void> _loadUserName() async {
    String? name = await _authService.getUserNameFromToken();
    setState(() {
      userName = name ?? "User";
    });
  }

  Future<void> _loadDoctors() async {
    try {
      List<dynamic> medicoList = await _medicoService.getAllMedicos();
      setState(() {
        doctors = medicoList;
      });
    } catch (e) {
      print("Error al cargar la lista de médicos: $e");
    }
  }

  Future<void> _loadEspecialidades() async {
    try {
      List<dynamic> especialidadList = await _especialidadService.getAllEspecialidades();
      setState(() {
        especialidades = especialidadList;
      });
    } catch (e) {
      print("Error al cargar la lista de especialidades: $e");
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hola, $userName",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[700],
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildOptionCard(
                title: "Hospital System",
                subtitle: "Brindamos Atención Médica",
                icon: Icons.local_hospital,
                color: Color(0xFF7165D6),
                iconColor: Colors.white,
                onTap: () {},
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Todas Nuestras Especialidades",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            _buildEspecialidadesList(),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Doctores Más Populares",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            doctors.isEmpty
                ? Center(child: CircularProgressIndicator())
                : _buildDoctorsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 35,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEspecialidadesList() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: especialidades.length,
        itemBuilder: (context, index) {
          final especialidad = especialidades[index]['nombre'] ?? 'Sin nombre';

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                especialidad,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorsGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      itemCount: doctors.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        final specialties = (doctor['especialidades'] as List<dynamic>?)
            ?.join(', ') ??
            "Sin especialidad";

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentScreen(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 15),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: doctor['image'] != null
                      ? NetworkImage(doctor['image'])
                      : null,
                  child: doctor['image'] == null
                      ? Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.grey[700],
                  )
                      : null,
                ),
                Text(
                  doctor['name'] ?? "Dr. Doctor Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  specialties,
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      "4.0",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}