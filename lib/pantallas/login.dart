import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/register.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    print('Correo electrónico: $email');
    print('Contraseña: $password');
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
              const SizedBox(height: 20),
              const Text(
                'KUNAN',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(178,219,144,1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 250,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //CORREO
                      const Text(
                        'Correo',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu correo', // Texto de sugerencia
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

                      //CONTRASEÑA
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu contraseña', // Texto de sugerencia
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
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(178,219,144,1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes una cuenta? ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}