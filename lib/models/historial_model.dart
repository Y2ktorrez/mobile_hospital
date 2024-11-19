class Historial {
  final int idPaciente;
  final List<Consulta> consultas;

  Historial({required this.idPaciente, required this.consultas});

  factory Historial.fromJson(Map<String, dynamic> json) {
    return Historial(
      idPaciente: json['id_paciente'],
      consultas: (json['consultas'] as List?)?.map((consultaJson) => Consulta.fromJson(consultaJson)).toList() ?? [],
    );
  }
}

class Consulta {
  final int id;
  final String fecha;
  final String diagnostico;
  final Preconsulta preconsulta;
  final List<Examen> examenes;
  final List<Analisis> analisis;
  final Ficha ficha; // Nueva propiedad de ficha

  Consulta({
    required this.id,
    required this.fecha,
    required this.diagnostico,
    required this.preconsulta,
    required this.examenes,
    required this.analisis,
    required this.ficha,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] ?? 0,
      fecha: json['fecha'] ?? 'Fecha no disponible',
      diagnostico: json['diagnostico'] ?? 'Diagnóstico no disponible',
      preconsulta: Preconsulta.fromJson(json['preconsultaDto'] ?? {}),
      examenes: (json['examen'] as List?)?.map((e) => Examen.fromJson(e)).toList() ?? [],
      analisis: (json['analisis'] as List?)?.map((a) => Analisis.fromJson(a)).toList() ?? [],
      ficha: Ficha.fromJson(json['ficha'] ?? {}),
    );
  }
}

class Preconsulta {
  final int id;
  final String estado;
  final Enfermero enfermero;
  final String preconsultaTerminada;

  Preconsulta({
    required this.id,
    required this.estado,
    required this.enfermero,
    required this.preconsultaTerminada,
  });

  factory Preconsulta.fromJson(Map<String, dynamic> json) {
    return Preconsulta(
      id: json['id'] ?? 0,
      estado: json['estado'] ?? 'Estado no disponible',
      enfermero: Enfermero.fromJson(json['enfermero'] ?? {}),
      preconsultaTerminada: json['preconsultaTerminada'] ?? 'No disponible',
    );
  }
}

class Ficha {
  final int id;
  final String fechaEmision;
  final String fechaAtencion;
  final String horaAtencion;
  final int ciPaciente;
  final int ciMedico;
  final String nombrePaciente;
  final String nombreMedico;
  final String nombreEspecialidad;
  final String fichaTerminada;

  Ficha({
    required this.id,
    required this.fechaEmision,
    required this.fechaAtencion,
    required this.horaAtencion,
    required this.ciPaciente,
    required this.ciMedico,
    required this.nombrePaciente,
    required this.nombreMedico,
    required this.nombreEspecialidad,
    required this.fichaTerminada,
  });

  factory Ficha.fromJson(Map<String, dynamic> json) {
    return Ficha(
      id: json['id'] ?? 0,
      fechaEmision: json['fechaEmision'] ?? 'Fecha no disponible',
      fechaAtencion: json['fechaAtencion'] ?? 'Fecha no disponible',
      horaAtencion: json['horaAtencion'] ?? 'Hora no disponible',
      ciPaciente: json['ci_paciente'] ?? 0,
      ciMedico: json['ci_medico'] ?? 0,
      nombrePaciente: json['nombrePaciente'] ?? 'Nombre no disponible',
      nombreMedico: json['nombreMedico'] ?? 'Nombre no disponible',
      nombreEspecialidad: json['nombreEspecialidad'] ?? 'Especialidad no disponible',
      fichaTerminada: json['fichaTerminada'] ?? 'No disponible',
    );
  }
}

class Enfermero {
  final int ci;
  final String name;
  final String email;

  Enfermero({
    required this.ci,
    required this.name,
    required this.email,
  });

  factory Enfermero.fromJson(Map<String, dynamic> json) {
    return Enfermero(
      ci: json['ci'] ?? 0,
      name: json['name'] ?? 'Nombre no disponible',
      email: json['email'] ?? 'Email no disponible',
    );
  }
}

class Examen {
  final int id;
  final String resultado;
  final String fecha;

  Examen({required this.id, required this.resultado, required this.fecha});

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'] ?? 0,
      resultado: json['resultado'] ?? 'Resultado no disponible',
      fecha: json['fecha'] ?? 'Fecha no disponible',
    );
  }
}

class Analisis {
  final int id;
  final String resultado;
  final String fecha;

  Analisis({required this.id, required this.resultado, required this.fecha});

  factory Analisis.fromJson(Map<String, dynamic> json) {
    return Analisis(
      id: json['id'] ?? 0,
      resultado: json['resultado'] ?? 'Resultado no disponible',
      fecha: json['fecha'] ?? 'Fecha no disponible',
    );
  }
}
