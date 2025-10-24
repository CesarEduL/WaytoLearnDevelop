import 'package:flutter/material.dart';

class SessionProgressScreen extends StatelessWidget {
  const SessionProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón Home arriba izquierda
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.home, color: Colors.orange, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Texto superior
                Text(
                  "Aprendizaje en curso",
                  style: TextStyle(
                    color: Colors.purple.shade300,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Sesión 2",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const Text(
                  "Palabras con Magia",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 16),

                // Barra de progreso general
                Stack(
                  children: [
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 16,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Comunicación 45%",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Grid de sesiones
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.4,
                    children: const [
                      _SessionCard(
                        title: "Sesión 1",
                        subtitle: "Las Vocales Aventureras",
                        progress: 1.0,
                        color: Colors.purple,
                      ),
                      _SessionCard(
                        title: "Sesión 2",
                        subtitle: "Palabras con Magia",
                        progress: 0.45,
                        color: Colors.green,
                      ),
                      _SessionCard(
                        title: "Sesión 3",
                        subtitle: "Cuentos con Emociones",
                        progress: 0.0,
                        color: Colors.cyan,
                      ),
                      _SessionCard(
                        title: "Sesión 4",
                        subtitle: "Cuentacuentos Comunicador",
                        progress: 0.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botón del libro (abajo derecha)
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {},
              child: const Icon(Icons.menu_book, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;

  const _SessionCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 4),
          Text(
            "${(progress * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
