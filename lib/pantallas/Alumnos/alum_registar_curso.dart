
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/custom_navigationbar.dart';

class Matricula {
  final String idCurso;
  final String idEstudiante;

  Matricula({
    required this.idCurso,
    required this.idEstudiante,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_curso': idCurso,
      'id_usuario': idEstudiante,
    };
  }
}



class EstRegistrarCurso extends StatefulWidget {
  const EstRegistrarCurso ({super.key});

  @override
  State<EstRegistrarCurso > createState() => _EstRegistrarCursoState();
}

class _EstRegistrarCursoState extends State<EstRegistrarCurso > {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  Future<void> _registrarCurso() async {
    if (_formKey.currentState!.validate()) {
      final matricula = Matricula(
        idCurso: "QmHlb0brHVJcX1Nlb4es",
        idEstudiante: "4CZv6v4huRSV3QUxo2R7", //Cambiar
      );

      try {
        final response = await http.post(
          Uri.parse('https://kunan.onrender.com/curso/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(matricula.toJson()),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Matrícula exitosa')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al matricularse')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocurrió un error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: size.height * 0.03,
            left: size.width * 0.09,
            right: size.width * 0.09),
        color: const Color(0xFF21283F),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Registro de Cursos',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nombreController, 'Nombre del Curso'),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _registrarCurso,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Matricularme',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 2,
        usuario: 'Alumno',
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    final size = MediaQuery
        .of(context)
        .size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          width: size.width * 0.8,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ingresa $label',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 10.0),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa $label';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}