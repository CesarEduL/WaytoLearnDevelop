import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:waytolearn/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:waytolearn/core/services/user_service.dart';
import 'package:waytolearn/core/providers/game_provider.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  String _title = "";
  String _content = "";
  String? _imageUrl;
  Map<String, dynamic>? _options;
  bool _isLoading = true;

  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isLoadingStory = false;

  @override
  void initState() {
    super.initState();
    _loadStory(widget.storyId);
    _initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("es-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.4);
    flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(String text) async {
    if (text.trim().isEmpty) return;

    if (_isSpeaking) {
      await flutterTts.stop();
      if (mounted) setState(() => _isSpeaking = false);
    } else {
      if (mounted) setState(() => _isSpeaking = true);
      await flutterTts.speak(text);
    }
  }

  Future<void> _loadStory(String storyId) async {
    if (_isLoadingStory) return;
    _isLoadingStory = true;

    await flutterTts.stop();

    if (mounted) {
      setState(() {
        _isLoading = true;
        _isSpeaking = false;
      });
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Cuentos')
          .doc(storyId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        if (mounted) {
          setState(() {
            _title = data['titulo_cuento'] ?? "Sin título";
            _content = data['contenido'] ?? "Contenido no disponible.";
            _imageUrl = data['imagen'];
            _options = data['opciones'] != null
                ? Map<String, dynamic>.from(data['opciones'])
                : null;

            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _title = "Cuento no encontrado";
            _content = "Este cuento no existe en la base de datos.";
            _imageUrl = null;
            _options = null;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _title = "Error";
          _content = "No se pudo cargar el cuento.";
          _isLoading = false;
        });
      }
    } finally {
      _isLoadingStory = false;
    }
  }

  Widget buildStoryImage() {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.accentColor.withOpacity(0.1),
            ],
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_imageUrl != null)
              Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppTheme.primaryColor,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(
                    Icons.auto_stories,
                    size: 80,
                    color: AppTheme.primaryColor,
                  ),
                ),
              )
            else
              Container(
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: const Icon(
                  Icons.auto_stories,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
            // Gradient overlay for better text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStoryText() {
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8C42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    _content,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.8,
                      color: Color(0xFF2C3E50),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SafeArea(top: false, child: buildOptionsSection()),
          ],
        ),
      ),
    );
  }

  Widget buildOptionsSection() {
    if (_options != null) {
      return Column(
        children: [
          const Text(
            "¿Qué quieres hacer?",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ..._options!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GameButton(
                text: entry.value['texto'] ?? "Opción",
                onTap: () {
                  final nextId = entry.value['subcuento_id'];
                  if (nextId != null) _loadStory(nextId);
                },
              ),
            );
          }).toList(),
        ],
      );
    }

    // FINAL DEL CUENTO
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _GameButton(
        text: "Terminar Cuento",
        color: AppTheme.primaryColor,
        icon: Icons.check_circle,
        onTap: endStory,
      ),
    );
  }

  Future<void> endStory() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    if (userService.currentUser != null) {
      try {
        final indexStr = widget.storyId.replaceAll(RegExp(r'[^0-9]'), '');
        final index = int.parse(indexStr) - 1;

        await gameProvider.unlockNextStoryForUser(
          userService.currentUser!.id,
          'communication',
          index,
        );
      } catch (e) {
        print('Error parsing story index: $e');
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Fondo amarillo suave para niños
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8C42)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isSpeaking 
                      ? [const Color(0xFFFF5252), const Color(0xFFFF1744)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isSpeaking ? Icons.stop : Icons.volume_up,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              onPressed: () => _speak(_content),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;
                
                if (isLandscape) {
                  return Row(
                    children: [
                      // Imagen a la izquierda (40%)
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: _imageUrl != null
                              ? Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image, size: 50, color: Colors.grey),
                                )
                              : const Icon(Icons.auto_stories, size: 50, color: Colors.grey),
                        ),
                      ),
                      
                      // Texto a la derecha (60%)
                      Expanded(
                        flex: 6,
                        child: SafeArea(
                          left: false,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8C42)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    _title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Text(
                                        _content,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          height: 1.8,
                                          color: Color(0xFF2C3E50),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                buildOptionsSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Layout Vertical (Original)
                  return Column(
                    children: [
                      buildStoryImage(),
                      buildStoryText(),
                    ],
                  );
                }
              },
            ),
    );
  }
}

class _GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;

  const _GameButton({
    required this.text,
    required this.onTap,
    this.color = const Color(0xFF00BFA5),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8)
            ],
            Flexible(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
