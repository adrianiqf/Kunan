import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/seleccionar_usuario.dart';

import '../Controladores/usario.dart';

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
  bool _passwordVisible = false;

  void _register() {
    String username = _userController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _password2Controller.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    if (usuario.existeUsuario(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El correo ya está registrado')),
      );
      return;
    }

    if (usuario.registrarUsuario(email, password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectUserScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar el usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.scale(
        scale: 1.4,
        child: Container(
          width: double.infinity,
          color: const Color(0xFF21283F),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imagenes/sombrero-de-graduacion.png'),
              const Text(
                'KUNAN',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(178,219,144,1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // USUARIO
                      const Text(
                        'Nombre de Usuario',
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
                          controller: _userController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu nombre de usuario',
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
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(178,219,144,1),
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
    );
  }
}
