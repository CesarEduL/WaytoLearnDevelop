import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId; // Ejemplo: "C01"

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

  @override
  void initState() {
    super.initState();
    _loadStory(widget.storyId);
  }

  Future<void> _loadStory(String storyId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Cuentos')
          .doc(storyId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _title = data['titulo_cuento'];
          _content = data['contenido'];
          _imageUrl = data['imagen'];
          _options = data['opciones'] != null ? Map<String, dynamic>.from(data['opciones']) : null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _title = "Cuento no encontrado";
          _content = "No hay información disponible.";
          _imageUrl = null;
          _options = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar cuento: $e');
      setState(() {
        _title = "Error";
        _content = "No se pudo obtener el cuento.";
        _isLoading = false;
      });
    }
  }

  void _goToOption(String subcuentoId) {
    // 🔹 Carga el siguiente subcuento
    _loadStory(subcuentoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title ?? "Cargando..."),
        backgroundColor: Colors.purple.shade700,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(_imageUrl!),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _content ?? "",
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  if (_options != null) ...[
                    const Text(
                      "Elige una opción:",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    for (var optionKey in _options!.keys)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          final nextId =
                              _options![optionKey]['subcuento_id'] ?? "";
                          if (nextId.isNotEmpty) {
                            _goToOption(nextId);
                          }
                        },
                        child: Text(
                          _options![optionKey]['texto'] ?? "Continuar",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                  ] else
                    const Center(
                      child: Text(
                        "Fin del cuento 🎉",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
