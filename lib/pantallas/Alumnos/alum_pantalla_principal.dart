

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/curso_widget.dart';
import 'package:http/http.dart' as http;

import '../../widgets/custom_navigationbar.dart';


class EstMainMenuScreen extends StatefulWidget {
  const EstMainMenuScreen({super.key});

  @override
  State<EstMainMenuScreen> createState() => _EstMainMenuScreenState();
}

class _EstMainMenuScreenState extends State<EstMainMenuScreen> {

  List<dynamic> _cursos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://kunan.onrender.com/usuario_info/info/OuVmuk1gaojmulu9AnhQ'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cursos = data['cursos'];
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
    return Scaffold(
      body: Container(

        color: const Color.fromRGBO(1,6,24,1),
        child: Column(
          children: [
            //LOGO
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/imagenes/sombrero-de-graduacion.png'),
                        ),
                        const Text(
                          'Kunan',
                          style: TextStyle(
                            fontSize: 50,
                            color: Color.fromRGBO(178,219,144,1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),


            Column(
              children: [

                //BIENVENIDA
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 50),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola!',
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'José Ruiz', //Nombre de usuario
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      width: 115,
                      height: 115,
                      child: Image.asset('assets/imagenes/fotoperfil2.png'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                //EN CURSO
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'En Curso',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(178,219,144,1),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),

                    CursoWidget(
                      curso: 'Taller de Software Movil',
                      siglas: 'TM',
                      color: Color.fromRGBO(255,194,120,1),
                      estado: 'Asistencia',
                      usuario: 'Alumno',
                    ),

                  ],
                ),

                const SizedBox(height: 30),

                //MIS CURSOS
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis Cursos',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(178,219,144,1),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),

                    CursoWidget(
                        curso: 'Gestión de Riesgos',
                        siglas: 'GR',
                        color: Color.fromRGBO(143,152,255,1),
                        estado: 'ninguno',
                        usuario: 'Profesor'),

                    SizedBox(height: 30),

                    CursoWidget(
                        curso: 'Minería de Datos',
                        siglas: 'MD',
                        color: Color.fromRGBO(74,210,201,1),
                        estado: 'ninguno',
                        usuario: 'Profesor'),

                    SizedBox(height: 30),

                    CursoWidget(
                        curso: 'Desarrollo de Tesis 1',
                        siglas: 'DT',
                        color: Color.fromRGBO(128,179,255,1),
                        estado: 'ninguno',
                        usuario: 'Profesor'),

                    SizedBox(height: 30),

                    CursoWidget(
                      curso: 'Taller de Software Movil',
                      siglas: 'TM',
                      color: Color.fromRGBO(255,194,120,1),
                      estado: 'ninguno',
                      usuario: 'Alumno',
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Alumno',
      ),
    );
  }
}
