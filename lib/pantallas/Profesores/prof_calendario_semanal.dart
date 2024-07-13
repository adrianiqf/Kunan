import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Controladores/Curso.dart';
import '../../Controladores/save_preferences.dart';
import '../../widgets/custom_navigationbar.dart';
import 'package:http/http.dart' as http;

class ProfCalendarioSemanal extends StatefulWidget {
  const ProfCalendarioSemanal({super.key});

  @override
  State<ProfCalendarioSemanal> createState() => _ProfCalendarioSemanalState();
}

class _ProfCalendarioSemanalState extends State<ProfCalendarioSemanal> {

  late String idUsuario;
  List<Curso> _cursos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    idUsuario = (await SharedPrefUtils.getString("userId"))!;

    final cursos = await SharedPrefUtils.getCourses('user_courses');

    if (cursos.isNotEmpty) {
      setState(() {
        _cursos = cursos;
        _isLoading = false;
      });
    } else {
      await _fetchCoursedta();
    }
  }

  Future<void> _fetchCoursedta() async {
    idUsuario = (await SharedPrefUtils.getString("userId"))!;
    print(idUsuario);
    try {
      final response = await http.get(
        Uri.parse(
            'https://kunan.onrender.com/usuario_info/user/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Response length: ${response.body.length}');

      if (response.statusCode == 200) {
          setState(() {
            print(response.statusCode);
            print(response.body);
            try {
              _cursos = parseCursos(response.body);
              print("Cursos parsed successfully");
            } catch (e) {
              print('Error parsing JSON: $e');
              // Muestra un snackbar con el error específico
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error parsing JSON: $e')),
              );
            }
            print("cursoss");
            print(_cursos);
          _isLoading = false;
        });
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedCursos = sortCursosByDiaYHora(_cursos);

    Map<String, List<Curso>> cursosPorDia = {};
    for (var curso in sortedCursos) {
      if (!cursosPorDia.containsKey(curso.dia)) {
        cursosPorDia[curso.dia] = [];
      }
      cursosPorDia[curso.dia]!.add(curso);
    }

    String formatHora(String hora) {
      final horas = hora.substring(0, 2);
      final minutos = hora.substring(2, 4);
      return '$horas:$minutos';
    }

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(1, 6, 24, 1),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.05),
                Container(
                  margin: EdgeInsets.only(right: constraints.maxWidth * 0.1),
                  child: Text(
                    'Horario',
                    style: TextStyle(
                      fontSize: constraints.maxWidth * 0.1,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: ListView(
                      children: cursosPorDia.keys.map((dia) {
                        return ExpansionTile(
                          title: Text(
                            dia,
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.065,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(178, 219, 144, 1),
                            ),
                          ),
                          children: cursosPorDia[dia]!.map((curso) {
                            final enProgreso = isCursoEnProgreso(curso);
                            return ListTile(
                              title: Text(
                                curso.nombre,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.06,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${formatHora(curso.horaInicio)} - ${formatHora(curso.horaFin)} \nSección: ${curso.seccion}',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.055,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (enProgreso)
                                    Text(
                                      'En progreso',
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth * 0.035,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                              isThreeLine: true,
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 1,
        usuario: 'Profesor',
      ),
    );
  }
}
