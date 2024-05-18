import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/inicio.dart';

import '../../widgets/custom_navigationbar.dart';

class logoutScreen extends StatelessWidget {
  const logoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(1,6,24,1),
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
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InicioScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(178,219,144,1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 2,
        usuario: 'Alumno',
      ),
    );

  }
}