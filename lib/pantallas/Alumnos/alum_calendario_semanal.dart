import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Controladores/Curso.dart';
import '../../Controladores/save_preferences.dart';
import '../../widgets/custom_navigationbar.dart';
import 'package:http/http.dart' as http;

class EstCalendarioSemanal extends StatefulWidget {
  const EstCalendarioSemanal({super.key});

  @override
  State<EstCalendarioSemanal> createState() => _EstCalendarioSemanalState();
}

class _EstCalendarioSemanalState extends State<EstCalendarioSemanal> {

  late String idUsuario;
  List<Curso> _cursos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoursedta();
  }


  Future<void> _fetchCoursedta() async {
    idUsuario = (await SharedPrefUtils.getString("userId"))!;
    try {
      final response = await http.get(
        Uri.parse(
            'https://kunan.onrender.com/usuario_info/user/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
      );
      print(
          "----------------------------------------------------------------------------------");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _cursos = parseCursos(response.body);
          _isLoading = false;
          print(jsonEncode(_cursos));
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
        color: const Color.fromRGBO(1,6,24,1),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: const Text(
                'Horario',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: cursosPorDia.keys.map((dia) {
                    return ExpansionTile(
                        title: Text(
                          dia,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color:  Color.fromRGBO(178, 219, 144, 1),
                          ),
                        ),
                      children: cursosPorDia[dia]!.map((curso) {
                        final enProgreso = isCursoEnProgreso(curso);
                        return ListTile(
                          title: Text(
                            curso.nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatHora(curso.horaInicio)} - ${formatHora(curso.horaFin)} \nSección: ${curso.seccion}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              if (enProgreso)
                                const Text(
                                  'En progreso',
                                  style: TextStyle(
                                    fontSize: 14,
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
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 1,
        usuario: 'Alumno',
      ),
    );
  }
}
