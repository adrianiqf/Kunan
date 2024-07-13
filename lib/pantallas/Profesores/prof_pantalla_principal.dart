import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/curso_widget.dart';
import 'package:http/http.dart' as http;
import '../../Controladores/Curso.dart';
import '../../widgets/custom_navigationbar.dart';
import '../../widgets/random_lightcolor.dart';
import '../../Controladores/save_preferences.dart';
import '../../Controladores/Curso.dart';

class ProfMainMenuScreen extends StatefulWidget {
  final String idUsuario;
  const ProfMainMenuScreen({super.key, required this.idUsuario});
  @override
  State<ProfMainMenuScreen> createState() => _ProfMainMenuScreenState();
}

class _ProfMainMenuScreenState extends State<ProfMainMenuScreen> {

  late String idUsuario;
  String _nombre = "";
  List<Curso> _cursos = [];
  bool _isLoading = true;
  List<Curso> _Cursos = [];

  Curso? _cursoEnCurso;

  @override
  void initState() {
    super.initState();
     _loadData();
    _printPreferences();
  }

  void _printPreferences() async {
    print("INFORMACION GUARDADA");
    await SharedPrefUtils.printAllValues();
  }

  Future<void> _loadData() async {
    idUsuario = (await SharedPrefUtils.getString("userId"))!;

    final cursos = await SharedPrefUtils.getCourses('user_courses');

    if (cursos.isNotEmpty) {
      setState(() {
        _cursos = cursos;
        print("Cursossss: ");
        print(_cursos);
        _cursoEnCurso = _getCursoEnCurso(_cursos);
        _isLoading = false;
      });
    } else {
      await _fetchCoursedta();
    }

    final nombre = await SharedPrefUtils.getString('nombres');
    if (nombre != null) {
      setState(() {
        _nombre = nombre;
      });
    } else {
      await _fetchUserData();
    }

  }


  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      await SharedPrefUtils.saveString('id', userData['id'] ?? '');
      await SharedPrefUtils.saveString(
          'apellidos', userData['apellidos'] ?? '');
      await SharedPrefUtils.saveString('codigo', userData['codigo'] ?? '');
      await SharedPrefUtils.saveString('correo', userData['correo'] ?? '');
      await SharedPrefUtils.saveBool(
          'esProfesor', userData['esProfesor'] ?? false);
      await SharedPrefUtils.saveString('escuela', userData['escuela'] ?? '');
      await SharedPrefUtils.saveString('facultad', userData['facultad'] ?? '');
      await SharedPrefUtils.saveString('nombres', userData['nombres'] ?? '');
      await SharedPrefUtils.saveBool("isLoggedIn", true);
      print('Datos de usuario guardados exitosamente');
    } catch (e) {
      print('Error al guardar datos de usuario: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://kunan.onrender.com/usuario_info/info/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nombre = data['nombres'];
          _isLoading = false;
        });

        if (data['codigo'] != null) {
          _saveUserData(data);
        }
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  Future<void> _fetchCoursedta() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://kunan.onrender.com/usuario_info/user/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
      );
      print("CURSOS BACKEND");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final courses = data['cursos'] as List<dynamic>;
        final courseNames =
        courses.map((course) => course['nombre'].toString()).toList();
        setState(() {
          //_cursos = courseNames;
          _cursos = parseCursos(response.body);
          print("cursosss");
          print(_cursos);
          _cursoEnCurso = _getCursoEnCurso(_cursos);
          _isLoading = false;
        });
        // Guardar cursos en SharedPreferences
        //await SharedPrefUtils.saveStringList('user_courses', courseNames);
        await SharedPrefUtils.saveCourses('user_courses', _cursos);

      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  Curso? _getCursoEnCurso(List<Curso> cursos) {
    for (var curso in cursos) {
      if (isCursoEnProgreso(curso)) {
        return curso;
      }
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
          color: const Color.fromRGBO(1,6,24,1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //LOGO
                Container(
                  margin: EdgeInsets.only(
                      top: size.height * 0.02, left: size.width * 0.1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.12,
                        height: size.height * 0.12,
                        child: Image.asset(
                            'assets/imagenes/sombrero-de-graduacion.png'),
                      ),
                      Text(
                        'Kunan',
                        style: TextStyle(
                          fontSize: size.width * 0.11,
                          color: const Color.fromRGBO(178, 219, 144, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),


                Column(
                  children: [

                    //BIENVENIDA
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '¡Hola!',
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _nombre,
                                style: const TextStyle(
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
                    Container(
                      margin: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.06),
                      alignment: Alignment.centerLeft,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'En Curso',
                            style: TextStyle(
                              fontSize: size.width * 0.09,
                              color: const Color.fromRGBO(178, 219, 144, 1),
                            ),
                          ),
                          if (_isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (_cursoEnCurso != null)
                            CursoWidget(
                              curso: _cursoEnCurso!.nombre,
                              siglas: _cursoEnCurso!.nombre.substring(0, 2).toUpperCase(),
                              color: getRandomLightColor(),
                              estado: 'En Curso',
                              usuario: 'Alumno',
                            )
                          else
                            const Text(
                              'No se está realizando ningún curso',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    TomarAsistenciaWidget(context:context, usuario: "Profesor"),

                    SizedBox(height: size.height * 0.03),

                    //MIS CURSOS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' Mis Cursos',
                          style: TextStyle(
                            fontSize: 40,
                            color: Color.fromRGBO(178,219,144,1),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          SizedBox(
                            width: 410,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _cursos.length,
                              itemBuilder: (context, index) {
                                final curso = _cursos[index];
                                final cursoNombre = curso.nombre;
                                final siglas = cursoNombre.substring(0, 2).toUpperCase();
                                final Color color = getRandomLightColor();
                                const estado = 'Sin estado';
                                const usuario = 'Profesor';

                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CursoWidget(
                                    curso: cursoNombre,
                                    siglas: siglas,
                                    color: color,
                                    estado: estado,
                                    usuario: usuario,
                                  ),
                                );
                              },
                            ),
                          ),

                      ],
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Profesor',
      ),
    );
  }
}
