import 'package:flutter/material.dart';
import '../services/orientation_service.dart';

class OrientationAwareWidget extends StatefulWidget {
  final Widget child;
  final bool forceLandscape;

  const OrientationAwareWidget({
    super.key,
    required this.child,
    this.forceLandscape = false,
  });

  @override
  State<OrientationAwareWidget> createState() => _OrientationAwareWidgetState();
}

class _OrientationAwareWidgetState extends State<OrientationAwareWidget> {
  @override
  void initState() {
    super.initState();
    // Si se fuerza landscape, configurar orientación horizontal automáticamente
    if (widget.forceLandscape) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        OrientationService().setLandscapeOnlyWithDelay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Si se fuerza landscape y estamos en portrait, mostrar mensaje temporal
        if (widget.forceLandscape && orientation == Orientation.portrait) {
          return _buildRotateMessage();
        }
        
        return widget.child;
      },
    );
  }

  Widget _buildRotateMessage() {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.screen_rotation,
              size: 80,
              color: Colors.blue[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Girando automáticamente...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'La aplicación se ajustará automáticamente',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Configurando orientación',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
