import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/inicio.dart';

import '../../widgets/custom_navigationbar.dart';

class ProflogoutScreen extends StatelessWidget {
  const ProflogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(1,6,24,1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            SizedBox(
              width: 115,
              height: 115,
              child: Image.asset('assets/imagenes/fotoperfil1.png'),
            ),
            const SizedBox(height: 20),

            const Text(
              'Rosa Ramos',
              style: TextStyle(
                fontSize: 32,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 240),
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
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 2,
        usuario: 'Profesor',
      ),
    );

  }
}