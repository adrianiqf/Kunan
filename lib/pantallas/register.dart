import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kunan_v01/pantallas/seleccionar_usuario.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  bool _passwordVisible = false;
  bool _isProfessor = false;

  Future<void> _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _password2Controller.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String code = _codeController.text;
    String school = _schoolController.text;
    String faculty = _facultyController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty ||
        firstName.isEmpty || lastName.isEmpty || code.isEmpty || school.isEmpty || faculty.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    if (!email.endsWith('@unmsm.edu.pe')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un correo de la UNMSM')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://kunan.onrender.com/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombres': firstName,
          'apellidos': lastName,
          'codigo': code,
          'correo': email,
          'esProfesor': _isProfessor,
          'escuela': school,
          'facultad': faculty,
          'password': password,
        }),
      );
      print(jsonEncode({
        'nombres': firstName,
        'apellidos': lastName,
        'codigo': code,
        'correo': email,
        'esProfesor': _isProfessor,
        'escuela': school,
        'facultad': faculty,
        'password': password,
      }),);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectUserScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['message'] ?? 'Error al registrar el usuario')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el servidor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.scale(
        scale: 1,
        child: Container(
          width: double.infinity,
          color: const Color(0xFF21283F),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/imagenes/sombrero-de-graduacion.png'),
                const Text(
                  'KUNAN',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOMBRES
                      const Text(
                        'Nombres',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tus nombres',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // APELLIDOS
                      const Text(
                        'Apellidos',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tus apellidos',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CÓDIGO
                      const Text(
                        'Código',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu código',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ESCUELA
                      const Text(
                        'Escuela',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _schoolController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu escuela',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // FACULTAD
                      const Text(
                        'Facultad',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _facultyController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu facultad',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ES PROFESOR
                      const Text(
                        '¿Eres profesor?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CheckboxListTile(
                        title: const Text(
                          'Sí',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: _isProfessor,
                        onChanged: (bool? value) {
                          setState(() {
                            _isProfessor = value!;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: const Color.fromRGBO(178, 219, 144, 1),
                      ),
                      const SizedBox(height: 20),

                      // CORREO
                      const Text(
                        'Correo',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu correo',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CONTRASEÑA
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              child: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: !_passwordVisible,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CONFIRMAR CONTRASEÑA
                      const Text(
                        'Confirmar Contraseña',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _password2Controller,
                          decoration: InputDecoration(
                            hintText: 'Confirma tu contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              child: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: !_passwordVisible,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(178, 219, 144, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Registrarme',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
