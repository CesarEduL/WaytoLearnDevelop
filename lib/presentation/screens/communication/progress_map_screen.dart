import 'package:flutter/material.dart';
import 'session_progress_screen.dart';

class ProgressMapScreen extends StatefulWidget {
  const ProgressMapScreen({super.key});

  @override
  State<ProgressMapScreen> createState() => _ProgressMapScreenState();
}

class _ProgressMapScreenState extends State<ProgressMapScreen> {
  // ✅ URLs desde Firebase Storage
  final Map<String, String> _urls = {
    'home':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FGroup%206.png?alt=media&token=74802f62-e83d-4322-b956-9196b47dc571',
    'bear':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FOSO%20CON%20UN%20LIBRO_%202.png?alt=media&token=ef9324fd-da34-49f3-a52b-7faf3121dc25',
    'settings':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcomunication-icon.png?alt=media&token=28186c74-b7d0-4914-b1e1-1b1f2b7a6bf0',
    'bookButton':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcomunication-icon2.png?alt=media&token=3fca4efc-eab2-44a3-8551-703bf86bc7b2',
    'bookDefault':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcuento-1.png?alt=media&token=153c8fbf-3ef5-4f38-a2b2-fca1bf04c737',
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

  // 🔹 Libros
  List<Widget> _buildBookIcons() {
    final bookUrl = _urls['bookDefault']!;
    final size = MediaQuery.of(context).size;

    return [
      Positioned(left: size.width * 0.08, top: size.height * 0.58, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(1))),
      Positioned(left: size.width * 0.18, top: size.height * 0.38, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(2))),
      Positioned(left: size.width * 0.30, top: size.height * 0.55, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(3))),
      Positioned(left: size.width * 0.48, top: size.height * 0.75, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(4))),
      Positioned(left: size.width * 0.62, top: size.height * 0.55, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(5))),
      Positioned(left: size.width * 0.75, top: size.height * 0.38, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(6))),
      Positioned(left: size.width * 0.88, top: size.height * 0.58, child: BookIcon(url: bookUrl, onTap: () => _onBookTap(7))),
    ];
  }

  // 🔹 Oso
  Widget _buildBearReading() {
    final url = _urls['bear']!;
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.43,
      top: MediaQuery.of(context).size.height * 0.20,
      child: BearIcon(url: url, onTap: _onBearTap),
    );
  }

  // 🔹 Botón Home
  Widget _buildHomeButton() {
    final url = _urls['home']!;
    return Positioned(
      top: 20,
      left: 20,
      child: MenuIcon(url: url, size: 60, onTap: () => Navigator.pop(context)),
    );
  }

  // 🔹 Botón Configuración
  Widget _buildSettingsButton() {
    final url = _urls['settings']!;
    return Positioned(
      top: 20,
      right: 20,
      child: MenuIcon(url: url, size: 90, onTap: _onSettingsTap),
    );
  }

  // 🔹 Botón Libro
  Widget _buildBookButton() {
    final url = _urls['bookButton']!;
    return Positioned(
      bottom: 5,
      right: 10,
      child: MenuIcon(url: url, size: 90, onTap: _onBookMenuTap),
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
      const SnackBar(
        content: Text('¡Hola! Soy tu compañero de aprendizaje'),
        backgroundColor: Colors.brown,
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración'),
        backgroundColor: Colors.purple,
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _onBookMenuTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menú de libros'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 800),
      ),
    );
  }
}

//
// 🔸 Widgets personalizados sin colores ni bordes
//

class BookIcon extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const BookIcon({super.key, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Image.network(url, width: 55, height: 55, fit: BoxFit.cover),
      ),
    );
  }
}

class BearIcon extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const BearIcon({super.key, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(70),
        child: Image.network(url, width: 120, height: 120, fit: BoxFit.cover),
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  final String url;
  final double size;
  final VoidCallback onTap;

  const MenuIcon({
    super.key,
    required this.url,
    required this.onTap,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Image.network(url, width: size, height: size, fit: BoxFit.cover),
      ),
    );
  }
}

//
// 🔸 Dotted path
//
class _DottedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.08, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.30, size.width * 0.30, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.70, size.width * 0.48, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.55, size.width * 0.75, size.height * 0.38);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.55, size.width * 0.95, size.height * 0.58);

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
