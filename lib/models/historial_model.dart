class Historial {
  final int idPaciente;
  final List<Consulta> consultas;

  Historial({required this.idPaciente, required this.consultas});

  factory Historial.fromJson(Map<String, dynamic> json) {
    return Historial(
      idPaciente: json['id_paciente'], // Valor por defecto en caso de que sea null
      consultas: (json['consultas'] as List?)?.map((consultaJson) => Consulta.fromJson(consultaJson)).toList() ?? [], // Manejo de lista nula
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

  Consulta({
    required this.id,
    required this.fecha,
    required this.diagnostico,
    required this.preconsulta,
    required this.examenes,
    required this.analisis,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] ?? 0, // Valor por defecto en caso de que sea null
      fecha: json['fecha'] ?? 'Fecha no disponible', // Valor por defecto
      diagnostico: json['diagnostico'] ?? 'Diagnóstico no disponible', // Valor por defecto
      preconsulta: Preconsulta.fromJson(json['preconsultaDto'] ?? {}),
      examenes: (json['examen'] as List?)
          ?.map((e) => Examen.fromJson(e))
          .toList() ??
          [], // Manejo de listas nulas
      analisis: (json['analisis'] as List?)
          ?.map((a) => Analisis.fromJson(a))
          .toList() ??
          [], // Manejo de listas nulas
    );
  }
}

class Preconsulta {
  final int id;
  final String estado;

  Preconsulta({required this.id, required this.estado});

  factory Preconsulta.fromJson(Map<String, dynamic> json) {
    return Preconsulta(
      id: json['id'] ?? 0, // Valor por defecto en caso de que sea null
      estado: json['estado'] ?? 'Estado no disponible', // Valor por defecto
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
      id: json['id'] ?? 0, // Valor por defecto en caso de que sea null
      resultado: json['resultado'] ?? 'Resultado no disponible', // Valor por defecto
      fecha: json['fecha'] ?? 'Fecha no disponible', // Valor por defecto
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
      id: json['id'] ?? 0, // Valor por defecto en caso de que sea null
      resultado: json['resultado'] ?? 'Resultado no disponible', // Valor por defecto
      fecha: json['fecha'] ?? 'Fecha no disponible', // Valor por defecto
    );
  }
}
