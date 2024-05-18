import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/curso_widget.dart';

import '../../widgets/custom_navigationbar.dart';


class ProfMainMenuScreen extends StatefulWidget {
  const ProfMainMenuScreen({super.key});

  @override
  State<ProfMainMenuScreen> createState() => _ProfMainMenuScreenState();
}

class _ProfMainMenuScreenState extends State<ProfMainMenuScreen> {
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
                              'Rosa Ramos', //Nombre de usuario
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
                        child: Image.asset('assets/imagenes/fotoperfil1.png'),
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
                          estado: 'En Curso',
                          usuario: 'Profesor',
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
                          curso: 'Desarrollo de Tesis',
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
                          usuario: 'Profesor'),

                    ],
                  ),

                ],
              ),
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
