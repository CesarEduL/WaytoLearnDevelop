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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  Future<void> _loadStory() async {
    try {
      // 🔹 Lee el documento desde la colección "cuentos"
      final doc = await FirebaseFirestore.instance
          .collection('Cuentos')
          .doc(widget.storyId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _title = data['titulo_cuento'];
          _content = data['contenido'];
          _imageUrl = data['imagen'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _title = "Cuento no encontrado";
          _content = "No hay información disponible.";
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
                ],
              ),
            ),
    );
  }
}
