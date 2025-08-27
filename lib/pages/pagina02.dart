import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pagina02 extends StatefulWidget {
  const Pagina02({super.key});

  @override
  State<Pagina02> createState() => _Pagina02State();
}

class _Pagina02State extends State<Pagina02> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedStoryId;
  Map<String, dynamic>? currentStory;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar el primer cuento por defecto
    loadStory('C01');
  }

  Future<void> loadStory(String storyId) async {
    setState(() {
      isLoading = true;
      selectedStoryId = storyId;
    });

    try {
      DocumentSnapshot storyDoc = await _firestore
          .collection('Cuentos')
          .doc(storyId)
          .get();

      if (storyDoc.exists) {
        setState(() {
          currentStory = storyDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          currentStory = null;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró el cuento $storyId')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el cuento: $e')),
      );
    }
  }

  void navigateToOption(String optionId) {
    loadStory(optionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WayToLearn - Cuentos'),
        backgroundColor: const Color.fromARGB(174, 73, 147, 221),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(174, 73, 147, 221),
              Colors.white,
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : currentStory == null
                ? const Center(
                    child: Text(
                      'No hay cuento disponible',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Imagen del cuento
                        if (currentStory!['imagen'] != null)
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                currentStory!['imagen'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 20),
                        
                        // Texto del cuento
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            currentStory!['texto'] ?? 'Sin texto disponible',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Opciones del cuento
                        if (currentStory!['opciones'] != null)
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '¿Qué quieres hacer?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(174, 73, 147, 221),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: currentStory!['opciones'].length,
                                      itemBuilder: (context, index) {
                                        String optionKey = 'Opcion${index + 1}';
                                        Map<String, dynamic> option = 
                                            currentStory!['opciones'][optionKey];
                                        
                                        if (option == null) return const SizedBox.shrink();
                                        
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: ElevatedButton(
                                            onPressed: () => navigateToOption(
                                                option['subcuento_id']),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(174, 73, 147, 221),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              elevation: 3,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    option['texto'] ?? 'Opción sin texto',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Volver al cuento principal
          if (selectedStoryId != null && 
              selectedStoryId!.length > 3) {
            String parentStoryId = selectedStoryId!.substring(0, 3);
            loadStory(parentStoryId);
          }
        },
        backgroundColor: const Color.fromARGB(174, 73, 147, 221),
        foregroundColor: Colors.white,
        child: const Icon(Icons.home),
        tooltip: 'Volver al inicio',
      ),
    );
  }
}
