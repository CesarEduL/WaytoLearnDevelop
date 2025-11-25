import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waytolearn/core/services/user_service.dart';
import 'package:waytolearn/core/theme/app_theme.dart';

class StoryPlayScreen extends StatefulWidget {
  final int storyIndex;

  const StoryPlayScreen({super.key, required this.storyIndex});

  @override
  State<StoryPlayScreen> createState() => _StoryPlayScreenState();
}

class _StoryPlayScreenState extends State<StoryPlayScreen> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0F2F1), // Teal muy suave
              Color(0xFFE8F5E9), // Verde muy suave
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con botón de regreso
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF00695C), size: 30),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Nivel ${widget.storyIndex + 1}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Contenido Central (Placeholder del Juego)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00695C).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calculate_rounded,
                      size: 80,
                      color: const Color(0xFF4DB6AC),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¡Hora de Aprender!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF004D40),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aquí iría el contenido interactivo del nivel ${widget.storyIndex + 1} de Matemáticas.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Botón de Completar
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isCompleting ? null : _completeLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA5),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isCompleting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            '¡Completar Nivel!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeLevel() async {
    setState(() => _isCompleting = true);
    
    try {
      final userService = Provider.of<UserService>(context, listen: false);
      
      // 1. Desbloquear siguiente nivel
      await userService.unlockNextStory('mathematics', widget.storyIndex);
      
      // 2. Agregar puntos
      await userService.addPoints(50);
      
      if (!mounted) return;
      
      // 3. Mostrar feedback y salir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Nivel completado! +50 puntos'),
          backgroundColor: Color(0xFF00BFA5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Esperar un poco para que se vea el feedback
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      Navigator.pop(context);
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }
}
