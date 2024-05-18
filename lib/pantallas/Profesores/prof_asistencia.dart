import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_reporte_asistencia.dart';
import 'package:kunan_v01/widgets/estudiantes_widget.dart';

import '../../widgets/custom_navigationbar.dart';


class ProfTomarAsistencia extends StatelessWidget {
  const ProfTomarAsistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color.fromRGBO(1,6,24,1),
        padding: const EdgeInsets.only(top: 30, left: 40),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //LOGO
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_left_outlined,
                        size: 36,
                        color: Colors.white,
                      ),
                      Text(
                        'Volver',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(right: 60),
              child: const Text(
                'Iniciar Asistencia',
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromRGBO(178,219,144,1),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 30),

            //Clase activa
            const Text(
              'Clase:',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(178,219,144,1),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Taller de Software Móvil',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            //Horario de asistencia
            const Text(
              'Horario de Aistencia',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(178,219,144,1),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Inicio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 120),

                        Text(
                          'Fin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    width: 345,
                    child: const Divider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '10:00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 120),

                        Text(
                          '10:10',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                  //const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(128,179,255,1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Iniciar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(128,179,255,1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            //Reporte de asistencias
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfReporteAsistencia()),
                );
              },
              child: const Text(
                'Reporte de asistencias',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Estudiantes inasistentes:',
              style: TextStyle(
                fontSize: 22,
                color: Color.fromRGBO(178,219,144,1),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),

            const EstudianteWidget(
                imagen: '2',
                nombre: 'Juan Lino Gutierrez',
                estado: 'Ausente'
            )

          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Profesor',
      ),
    );
  }
}
