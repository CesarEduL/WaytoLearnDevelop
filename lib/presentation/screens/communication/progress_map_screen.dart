import 'package:flutter/material.dart';
import 'session_progress_screen.dart';

class ProgressMapScreen extends StatefulWidget {
  const ProgressMapScreen({super.key});

  @override
  State<ProgressMapScreen> createState() => _ProgressMapScreenState();
}

class _ProgressMapScreenState extends State<ProgressMapScreen> {
  // ✅ URLs directas desde Firebase Storage
  final Map<String, String> _urls = {
    'home': 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FGroup%206.png?alt=media&token=74802f62-e83d-4322-b956-9196b47dc571',
    'bear': 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FOSO%20CON%20UN%20LIBRO_%202.png?alt=media&token=ef9324fd-da34-49f3-a52b-7faf3121dc25',
    'settings': 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcomunication-icon.png?alt=media&token=28186c74-b7d0-4914-b1e1-1b1f2b7a6bf0',
    'bookButton': 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcomunication-icon2.png?alt=media&token=3fca4efc-eab2-44a3-8551-703bf86bc7b2',
    'bookDefault': 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcuento-1.png?alt=media&token=153c8fbf-3ef5-4f38-a2b2-fca1bf04c737',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DottedPathPainter())),
          ..._buildBookIcons(),
          _buildBearReading(),
          _buildHomeButton(),
          _buildSettingsButton(),
          _buildBookButton(),
        ],
      ),
    );
  }

  // 🔹 Helper: imagen circular
  Widget _networkCircle(String url, {double size = 60}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }

  // 🔹 Libros (7 posiciones según la imagen)
  List<Widget> _buildBookIcons() {
    final bookUrl = _urls['bookDefault']!;
    final size = MediaQuery.of(context).size;

    return [
      Positioned(left: size.width * 0.08, top: size.height * 0.58, child: _bookIconFromUrl(bookUrl, 1)),
      Positioned(left: size.width * 0.18, top: size.height * 0.38, child: _bookIconFromUrl(bookUrl, 2)),
      Positioned(left: size.width * 0.30, top: size.height * 0.55, child: _bookIconFromUrl(bookUrl, 3)),
      Positioned(left: size.width * 0.43, top: size.height * 0.42, child: _bookIconFromUrl(bookUrl, 4)),
      Positioned(left: size.width * 0.58, top: size.height * 0.32, child: _bookIconFromUrl(bookUrl, 5)),
      Positioned(left: size.width * 0.72, top: size.height * 0.55, child: _bookIconFromUrl(bookUrl, 6)),
      Positioned(left: size.width * 0.88, top: size.height * 0.42, child: _bookIconFromUrl(bookUrl, 7)),
    ];
  }

  Widget _bookIconFromUrl(String url, int bookNumber) {
    return GestureDetector(
      onTap: () => _onBookTap(bookNumber),
      child: _networkCircle(url, size: 60),
    );
  }

  // 🔹 Oso lector (centro)
  Widget _buildBearReading() {
    final url = _urls['bear']!;
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.5 - 70,
      top: MediaQuery.of(context).size.height * 0.4 - 70,
      child: GestureDetector(
        onTap: _onBearTap,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(color: Colors.brown.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  // 🔹 Botón Home
  Widget _buildHomeButton() {
    final url = _urls['home']!;
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: _networkCircle(url, size: 60),
      ),
    );
  }

  // 🔹 Botón Configuración
  Widget _buildSettingsButton() {
    final url = _urls['settings']!;
    return Positioned(
      top: 20,
      right: 20,
      child: GestureDetector(
        onTap: _onSettingsTap,
        child: _networkCircle(url, size: 90),
      ),
    );
  }

  // 🔹 Botón Libro
  Widget _buildBookButton() {
    final url = _urls['bookButton']!;
    return Positioned(
      bottom: 30,
      right: 20,
      child: GestureDetector(
        onTap: _onBookMenuTap,
        child: _networkCircle(url, size: 90),
      ),
    );
  }

  // 🔹 Acciones
  void _onBookTap(int bookNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SessionProgressScreen(sessionNumber: bookNumber)),
    );
  }

  void _onBearTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Hola! Soy tu compañero de aprendizaje'), backgroundColor: Colors.brown),
    );
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración'), backgroundColor: Colors.purple),
    );
  }

  void _onBookMenuTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menú de libros'), backgroundColor: Colors.green),
    );
  }
}

// 🔹 Camino tipo gusano
class _DottedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10 // más grueso
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // 🔹 Camino en forma de gusano con curvas suaves
    path.moveTo(size.width * 0.08, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.30, size.width * 0.28, size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.38, size.height * 0.70, size.width * 0.48, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.35, size.width * 0.62, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.72, size.height * 0.70, size.width * 0.80, size.height * 0.40);
    path.quadraticBezierTo(size.width * 0.90, size.height * 0.55, size.width * 0.95, size.height * 0.45);

    // 🔹 Efecto punteado
    const dashWidth = 22.0;
    const dashSpace = 12.0;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final segment = metric.extractPath(distance, next);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
