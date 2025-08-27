import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/story_service.dart';
import '../../../core/models/story_node.dart';
import '../../../core/theme/app_theme.dart';

class StoryScreen extends StatefulWidget {
  final String startNodeId;
  const StoryScreen({super.key, required this.startNodeId});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  StoryNode? _current;
  bool _loading = true;
  int _accumulatedScore = 0;

  @override
  void initState() {
    super.initState();
    _loadNode(widget.startNodeId);
  }

  Future<void> _loadNode(String nodeId) async {
    setState(() => _loading = true);
    final service = Provider.of<StoryService>(context, listen: false);
    final node = await service.fetchStoryNode(nodeId);
    setState(() {
      _current = node;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_current?.storyTitle ?? 'Cuento'),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _current == null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.redAccent, size: 40),
          const SizedBox(height: 8),
          const Text('No se pudo cargar el cuento'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _loadNode(widget.startNodeId),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final node = _current!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (node.imageUrl != null && node.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(node.imageUrl!, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text(
            node.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            node.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 20),
          if (!node.isFinal)
            ...node.options.map((opt) => _buildOptionButton(opt))
          else
            _buildFinalSection(node),
        ],
      ),
    );
  }

  Widget _buildOptionButton(StoryOption option) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () => _onOptionSelected(option.subStoryId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(option.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void _onOptionSelected(String nextId) async {
    // Acumular puntaje si el nodo actual lo tiene
    if (_current?.score != null) {
      _accumulatedScore += _current!.score!;
    }
    await _loadNode(nextId);
  }

  Widget _buildFinalSection(StoryNode node) {
    if (node.score != null) {
      _accumulatedScore += node.score!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Text('¡Fin del cuento!'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 8),
            Text('Puntaje obtenido: $_accumulatedScore'),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _loadNode(widget.startNodeId),
          icon: const Icon(Icons.refresh),
          label: const Text('Volver a empezar'),
        ),
      ],
    );
  }
}


