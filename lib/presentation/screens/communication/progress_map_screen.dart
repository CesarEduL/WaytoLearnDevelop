import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'session_progress_screen.dart';



class ProgressMapScreen extends StatefulWidget {
  const ProgressMapScreen({super.key});

  @override
  State<ProgressMapScreen> createState() => _ProgressMapScreenState();
}

class _ProgressMapScreenState extends State<ProgressMapScreen> {
  String? _bearImageUrl;
  bool _isLoading = true;

@override
void initState() {
  super.initState();
 
  print('ProgressMapScreen: initState llamado');

  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      print('ProgressMapScreen: _isLoading = false');
    }
  });

  // TODO: Descomentar cuando tengas Firebase configurado
  _loadImages();
}


  // TODO: Descomentar cuando tengas Firebase Storage configurado
  Future<void> _loadImages() async {
    try {
      // Cargar imagen del oso desde Firebase Storage
      final bearRef = FirebaseStorage.instance.ref().child('images/bear_reading.png');
      final bearUrl = await bearRef.getDownloadURL();
      
      setState(() {
        _bearImageUrl = bearUrl;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando imágenes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
          child: CustomPaint(
          painter: _DottedPathPainter(),
          ),
          ),

          // Contenido de prueba
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
              ],
            ),
          ),

          // Íconos de libros a lo largo del camino
          ..._buildBookIcons(),

          // Oso leyendo en el centro
          _buildBearReading(),

          // Botón Home (arriba izquierda)
          _buildHomeButton(),

          // Botón Configuración (arriba derecha)
          _buildSettingsButton(),

          // Botón Libro (abajo derecha)
          _buildBookButton(),
        ],
      ),
    );
  }

  List<Widget> _buildBookIcons() {
    return [
      // Libro 1
      Positioned(
        left: MediaQuery.of(context).size.width * 0.15 - 25,
        top: MediaQuery.of(context).size.height * 0.25 - 25,
        child: _buildBookIcon(1, false),
      ),
      // Libro 2
      Positioned(
        left: MediaQuery.of(context).size.width * 0.3 - 25,
        top: MediaQuery.of(context).size.height * 0.45 - 25,
        child: _buildBookIcon(2, false),
      ),
      // Libro 3
      Positioned(
        left: MediaQuery.of(context).size.width * 0.45 - 25,
        top: MediaQuery.of(context).size.height * 0.65 - 25,
        child: _buildBookIcon(3, false),
      ),
      // Libro 4
      Positioned(
        left: MediaQuery.of(context).size.width * 0.6 - 25,
        top: MediaQuery.of(context).size.height * 0.5 - 25,
        child: _buildBookIcon(4, false),
      ),
      // Libro 5
      Positioned(
        left: MediaQuery.of(context).size.width * 0.75 - 25,
        top: MediaQuery.of(context).size.height * 0.3 - 25,
        child: _buildBookIcon(5, false),
      ),
      // Libro 6
      Positioned(
        left: MediaQuery.of(context).size.width * 0.9 - 25,
        top: MediaQuery.of(context).size.height * 0.5 - 25,
        child: _buildBookIcon(6, false),
      ),
    ];
  }

  Widget _buildBookIcon(int bookNumber, bool isCompleted) {
    return GestureDetector(
      onTap: () => _onBookTap(bookNumber),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green : Colors.grey.shade300,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted ? Colors.green.shade700 : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.menu_book_rounded,
          color: isCompleted ? Colors.white : Colors.grey.shade600,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildBearReading() {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.5 - 60,
      top: MediaQuery.of(context).size.height * 0.4 - 60,
      child: GestureDetector(
        onTap: () => _onBearTap(),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _bearImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    _bearImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildBearPlaceholder();
                    },
                  ),
                )
              : _buildBearPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildBearPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade300,
        borderRadius: BorderRadius.circular(60),
      ),
      child: const Icon(
        Icons.pets,
        size: 60,
        color: Colors.brown,
      ),
    );
  }

  Widget _buildHomeButton() {
    return Positioned(
      top: 30,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.home,
            color: Colors.blue.shade800,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Positioned(
      top: 30,
      right: 20,
      child: GestureDetector(
        onTap: () => _onSettingsTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.shade200,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return Positioned(
      bottom: 30,
      right: 20,
      child: GestureDetector(
        onTap: () => _onBookMenuTap(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.menu_book,
            color: Colors.purple.shade700,
            size: 30,
          ),
        ),
      ),
    );
  }

  void _onBookTap(int bookNumber) {
    // Navegar a la sesión específica del libro
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SessionProgressScreen(sessionNumber: bookNumber),
      ),
    );
  }

  void _onBearTap() {
    // TODO: Mostrar información del progreso o animación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Hola! Soy tu compañero de aprendizaje'),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _onSettingsTap() {
    // TODO: Abrir configuración
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _onBookMenuTap() {
    // TODO: Abrir menú de libros o progreso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menú de libros'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Pintor para el camino punteado
class _DottedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Crear un camino curvo en forma de S
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5,
      size.width * 0.4, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.55, size.height * 0.5,
      size.width * 0.7, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.85, size.height * 0.5,
      size.width * 0.95, size.height * 0.4,
    );

    // Dibujar línea punteada
    const dashWidth = 12.0;
    const dashSpace = 8.0;
    double distance = 0.0;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(distance, nextDistance);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
