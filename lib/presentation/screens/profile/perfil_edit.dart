import 'package:flutter/material.dart';

class PerfilEditPage extends StatefulWidget {
  const PerfilEditPage({super.key});

  @override
  State<PerfilEditPage> createState() => _PerfilEditPageState();
}

class _PerfilEditPageState extends State<PerfilEditPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF9D65C9), Color(0xFFB37CF5)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Botón de volver
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Imagen del osito
                  Image.network(
  'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FOSO%20in%20(1).png?alt=media&token=95f29ef7-fbf9-4d2c-90ed-e814487a7e0c',
  height: 180,
  fit: BoxFit.contain,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return const CircularProgressIndicator(color: Colors.white);
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.broken_image, color: Colors.white, size: 100);
  },
),


                  const SizedBox(height: 10),

                  // Mensaje
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Text(
                      'Bien, es hora de editar tus datos',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Campo de correo
                  _buildTextField(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    label: 'Edite su correo',
                  ),

                  const SizedBox(height: 20),

                  // Campo de contraseña
                  _buildTextField(
                    controller: passwordController,
                    icon: Icons.lock_outline,
                    label: 'Edite su contraseña',
                    obscureText: true,
                  ),

                  const SizedBox(height: 40),

                  // Botón guardar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos guardados')),
                      );
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Color(0xFF9D65C9),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF9D65C9)),
          hintText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
