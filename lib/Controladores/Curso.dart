import 'dart:convert';

class Curso {
  final String nombre;
  final String horaInicio;
  final String horaFin;
  final String dia;
  final double duracion;
  final String id;
  final String seccion;

  Curso({
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    required this.dia,
    required this.duracion,
    required this.id,
    required this.seccion,
  });

  // Convertir un Curso a un Map
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'hora_fin': horaFin,
      'hora_inicio': horaInicio,
      'dia': dia,
      'duracion': duracion,
      'id': id,
      'seccion': seccion,
    };
  }

  // Crear un Curso desde un Map
  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      nombre: json['nombre'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      dia: json['dia'] ?? '',
      duracion: (json['duracion'] ?? 0).toDouble(),
      id: json['id'] ?? '',
      seccion: json['seccion'] ?? '',
    );
  }
}

List<Curso> parseCursos(String responseBody) {
  final parsed = json.decode(responseBody);
  return (parsed['cursos'] as List).map<Curso>((json) => Curso.fromJson(json)).toList();
}

List<Curso> sortCursosByDiaYHora(List<Curso> cursos) {
  cursos.sort((a, b) {
    final diaComparison = a.dia.compareTo(b.dia);
    if (diaComparison != 0) return diaComparison;

    final horaInicioA = DateTime.parse('2024-01-01 ${a.horaInicio.substring(0, 2)}:${a.horaInicio.substring(2, 4)}');
    final horaInicioB = DateTime.parse('2024-01-01 ${b.horaInicio.substring(0, 2)}:${b.horaInicio.substring(2, 4)}');

    return horaInicioA.compareTo(horaInicioB);
  });

  return cursos;
}

bool isCursoEnProgreso(Curso curso) {
  final now = DateTime.now();
  final diaHoy = now.weekday;

  Map<String, int> diasDeLaSemana = {
    'Lunes': 1,
    'Martes': 2,
    'Miércoles': 3,
    'Jueves': 4,
    'Viernes': 5,
    'Sábado': 6,
    'Domingo': 7,
  };

  if (diasDeLaSemana[curso.dia] != diaHoy) return false;

  final horaInicio = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(curso.horaInicio.substring(0, 2)),
    int.parse(curso.horaInicio.substring(2, 4)),

  );

  final horaFin = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(curso.horaFin.substring(0, 2)),
    int.parse(curso.horaFin.substring(2, 4)),
  );

  return now.isAfter(horaInicio) && now.isBefore(horaFin);
}
