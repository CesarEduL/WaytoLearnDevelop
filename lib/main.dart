import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Imagen central
              Image.asset(
                'assets/images/baymaxface.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              // Botones
              const Padding(
                padding: EdgeInsets.only(right: 120), // Relleno a la derecha
                child: CustomButton(
                  icon: Icons.book,
                  text: 'Cuento 1',
                ),
              ),
              const SizedBox(height: 20), // Espacio vertical entre botones
              const Padding(
                padding: EdgeInsets.only(
                    left: 140), // Relleno a la izquierda y a la derecha
                child: CustomButton(
                  icon: Icons.book,
                  text: 'Cuento 2',
                ),
              ),
              const SizedBox(height: 20), // Espacio vertical entre botones
              const Padding(
                padding: EdgeInsets.only(right: 120), // Relleno a la izquierda
                child: CustomButton(
                  icon: Icons.book,
                  text: 'Cuento 3',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ElevatedButton(
        onPressed: () {
          // Acción cuando se presiona el botón
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(174, 73, 147, 221),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
