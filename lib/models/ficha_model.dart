class FichaDto {
  final DateTime fechaEmision;
  final DateTime fechaAtencion;
  final String horaAtencion;  // Usar String para la hora en formato "HH:mm"
  final int ciPaciente;
  final int ciMedico;
  final int idEspecialidad;

  FichaDto({
    required this.fechaEmision,
    required this.fechaAtencion,
    required this.horaAtencion,
    required this.ciPaciente,
    required this.ciMedico,
    required this.idEspecialidad,
  });

  // Método para convertir el objeto a un JSON
  Map<String, dynamic> toJson() {
    return {
      'fechaEmision': _formatDate(fechaEmision),
      'fechaAtencion': _formatDate(fechaAtencion),
      'horaAtencion': horaAtencion,  // Se espera una cadena en formato "HH:mm"
      'ci_paciente': ciPaciente,
      'ci_medico': ciMedico,
      'id_especialidad': idEspecialidad,
    };
  }

  // Método para formatear las fechas en "YYYY-MM-DD"
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Método para crear un objeto FichaDto desde un JSON
  factory FichaDto.fromJson(Map<String, dynamic> json) {
    return FichaDto(
      fechaEmision: DateTime.parse(json['fechaEmision']),
      fechaAtencion: DateTime.parse(json['fechaAtencion']),
      horaAtencion: json['horaAtencion'],  // Se espera que sea un string como "14:30"
      ciPaciente: json['ci_paciente'],
      ciMedico: json['ci_medico'],
      idEspecialidad: json['id_especialidad'],
    );
  }
}
