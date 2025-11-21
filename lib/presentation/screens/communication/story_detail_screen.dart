import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Dejarlo por si acaso, pero no lo usaremos en el build
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:waytolearn/core/theme/app_theme.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  String? _title;
  String? _content;
  String? _imageUrl;
  Map<String, dynamic>? _options;
  bool _isLoading = true;

  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    // NOTA: Ya no forzamos orientación aquí. El mapa ya nos puso en Vertical.
    _loadStory(widget.storyId);
    _initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    // NOTA: Ya no forzamos orientación aquí. El mapa lo hará al recuperar el control.
    super.dispose();
  }

  // ... (Lógica de TTS y Carga IGUAL que antes) ...
  Future<void> _initTts() async {
    await flutterTts.setLanguage("es-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.4);
    flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await flutterTts.stop();
      if (mounted) setState(() => _isSpeaking = false);
    } else {
      if (mounted) setState(() => _isSpeaking = true);
      await flutterTts.speak(text);
    }
  }

  Future<void> _loadStory(String storyId) async {
    await flutterTts.stop();
    if (mounted)
      setState(() {
        _isLoading = true;
        _isSpeaking = false;
      });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Cuentos')
          .doc(storyId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        if (mounted) {
          setState(() {
            _title = data['titulo_cuento'];
            _content = data['contenido'];
            _imageUrl = data['imagen'];
            _options = data['opciones'] != null
                ? Map<String, dynamic>.from(data['opciones'])
                : null;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ¡IMPORTANTE! Aquí quitamos el SystemChrome.setPreferredOrientations
    // El build ahora está LIMPIO y no causará rebotes.

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back_rounded, color: AppTheme.primaryColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: _isSpeaking ? Colors.redAccent : Colors.white,
                child: Icon(
                  _isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                  color: _isSpeaking ? Colors.white : AppTheme.primaryColor,
                ),
              ),
              onPressed: () => _speak(_content ?? ""),
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. IMAGEN (40%)
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _imageUrl != null
                        ? Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey),
                          )
                        : const Icon(Icons.auto_stories,
                            size: 50, color: Colors.grey),
                  ),
                ),

                // 2. TEXTO Y BOTONES (60%)
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      children: [
                        if (_title != null)
                          Text(
                            _title!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              _content ?? "Fin del cuento.",
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: Colors.black87,
                                fontFamily: "Round",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SafeArea(
                          top: false,
                          child: _options != null
                              ? Column(
                                  children: [
                                    const Text(
                                      "¿Qué quieres hacer?",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    ..._options!.entries.map((entry) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: _GameButton(
                                          text:
                                              entry.value['texto'] ?? "Opción",
                                          onTap: () {
                                            final nextId =
                                                entry.value['subcuento_id'];
                                            if (nextId != null)
                                              _loadStory(nextId);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: _GameButton(
                                    text: "Volver a empezar",
                                    color: Colors.orange,
                                    icon: Icons.replay,
                                    onTap: () => _loadStory(widget.storyId),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
