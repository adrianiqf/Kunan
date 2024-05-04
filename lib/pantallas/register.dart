import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              const Text(
                '¿Quién soy?',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.white,
                ),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/imagenes/estudiante_registro.png'),
                        radius: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Profesor',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],

                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.white,
                ),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/imagenes/profesor_registro.png'),
                        radius: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Profesor',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}