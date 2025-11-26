import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/interactive_story_model.dart';
import '../../../core/services/content_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../widgets/common/story_completion_dialog.dart';

class StoryScreen extends StatefulWidget {
  final StoryModel story;
  final String subjectId;
  final String sessionId;

  const StoryScreen({
    super.key, 
    required this.story,
    required this.subjectId,
    required this.sessionId,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  StoryNode? _currentNode;
  bool _loading = true;
  
  @override
  void initState() {
    super.initState();
    _loadStartNode();
  }

  Future<void> _loadStartNode() async {
    setState(() => _loading = true);
    await _loadNode('start');
  }

  Future<void> _loadNode(String nodeId) async {
    setState(() => _loading = true);
    final contentService = Provider.of<ContentService>(context, listen: false);
    
    try {
      final node = await contentService.getStoryNode(
        widget.subjectId, 
        widget.sessionId, 
        widget.story.id, 
        nodeId
      );

      if (node != null) {
        setState(() {
          _currentNode = node;
          _loading = false;
        });
      } else {
        debugPrint('Node $nodeId not found');
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint('Error loading node: $e');
      setState(() => _loading = false);
    }
  }

  void _navigateToNode(String nodeId) {
    if (nodeId == 'end' || nodeId.isEmpty) {
      _finishStory();
      return;
    }
    _loadNode(nodeId);
  }

  Future<void> _finishStory() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final userId = userService.currentUser?.id;

    if (userId != null) {
      final progressService = Provider.of<ProgressService>(context, listen: false);
      await progressService.markStoryCompleted(
        userId, 
        widget.subjectId, 
        widget.story.id
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StoryCompletionDialog(
        onContinue: () {
          Navigator.pop(context); // Close dialog
          Navigator.pop(context, true); // Go back to map and signal refresh
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con gradiente suave para niños
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Cyan muy suave
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.primaryColor),
                    ),
                    Expanded(
                      child: Text(
                        widget.story.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balancear el icono de back
                  ],
                ),
              ),
              
              Expanded(
                child: _loading
                    ? const LoadingWidget(size: 80, color: AppTheme.secondaryColor)
                    : _currentNode == null
                        ? _buildError()
                        : ResponsiveLayout(
                            mobileBody: _buildVerticalLayout(_currentNode!),
                            desktopBody: _buildHorizontalLayout(_currentNode!),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 60),
          const SizedBox(height: 16),
          const Text(
            '¡Ups! Algo salió mal.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadStartNode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Intentar de nuevo'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout(StoryNode node) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildImageCard(node.image),
          const SizedBox(height: 24),
          _buildStoryText(node.text),
          const SizedBox(height: 32),
          ...node.options.map((opt) => _buildOptionButton(opt)),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(StoryNode node) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: _buildImageCard(node.image),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStoryText(node.text),
                  const SizedBox(height: 40),
                  ...node.options.map((opt) => _buildOptionButton(opt)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 300, // Altura fija pero generosa
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Builder(
          builder: (context) {
            final url = imageUrl.trim();
            return Image.network(
              url,
              fit: BoxFit.contain, // Mantiene la proporción completa
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const LoadingWidget(size: 50, color: AppTheme.secondaryColor);
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image_rounded, size: 50, color: Colors.grey),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'No se pudo cargar la imagen\n$error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }

  Widget _buildStoryText(String text) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          height: 1.5,
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionButton(StoryOption option) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: () => _navigateToNode(option.nextNodeId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          shadowColor: AppTheme.secondaryColor.withOpacity(0.4),
        ),
        child: Text(
          option.text, 
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

