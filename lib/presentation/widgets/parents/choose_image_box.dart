import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChooseImageBox extends StatefulWidget {
  final String? currentImageUrl;
  final Function(String) onImageSelected;

  const ChooseImageBox({
    super.key,
    this.currentImageUrl,
    required this.onImageSelected,
  });

  @override
  State<ChooseImageBox> createState() => _ChooseImageBoxState();
}

class _ChooseImageBoxState extends State<ChooseImageBox> {
  Offset? _currentPointerPosition;
  
  // Predefined avatar options - 3D animated animals
  static const List<String> _predefinedAvatars = [
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Lion.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Panda.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Rabbit%20Face.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Cat%20Face.png',
    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Dog%20Face.png',
  ];

  Future<void> _pickImageFromGallery() async {
    // Por ahora muestra un mensaje, se implementará con image_picker más adelante
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de cargar imagen en desarrollo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showImageFullScreen(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(imageUrl: imageUrl),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        setState(() => _currentPointerPosition = event.localPosition);
      },
      onPointerMove: (event) {
        setState(() => _currentPointerPosition = event.localPosition);
      },
      onPointerUp: (event) {
        setState(() => _currentPointerPosition = null);
      },
      onPointerCancel: (event) {
        setState(() => _currentPointerPosition = null);
      },
      child: SizedBox(
        width: 418,
        height: 194,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Current image - centered
            Positioned(
              left: 157,
              top: 0,
              child: _ImageCircle(
                imageUrl: widget.currentImageUrl,
                size: 104,
                isMain: true,
                onTap: () => _showImageFullScreen(context, widget.currentImageUrl),
                pointerPosition: _currentPointerPosition,
                position: const Offset(157, 0),
              ),
            ),
            // 5 predefined avatars + upload option
            Positioned(
              left: 0,
              top: 134,
              child: SizedBox(
                width: 418,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar 1
                    _ImageCircle(
                      imageUrl: _predefinedAvatars[0],
                      size: 60,
                      isMain: false,
                      onTap: () => widget.onImageSelected(_predefinedAvatars[0]),
                      pointerPosition: _currentPointerPosition,
                      position: const Offset(19, 134),
                    ),
                    const SizedBox(width: 10),
                    // Avatar 2
                    _ImageCircle(
                      imageUrl: _predefinedAvatars[1],
                      size: 60,
                      isMain: false,
                      onTap: () => widget.onImageSelected(_predefinedAvatars[1]),
                      pointerPosition: _currentPointerPosition,
                      position: const Offset(89, 134),
                    ),
                    const SizedBox(width: 10),
                    // Avatar 3
                    _ImageCircle(
                      imageUrl: _predefinedAvatars[2],
                      size: 60,
                      isMain: false,
                      onTap: () => widget.onImageSelected(_predefinedAvatars[2]),
                      pointerPosition: _currentPointerPosition,
                      position: const Offset(159, 134),
                    ),
                    const SizedBox(width: 10),
                    // Avatar 4
                    _ImageCircle(
                      imageUrl: _predefinedAvatars[3],
                      size: 60,
                      isMain: false,
                      onTap: () => widget.onImageSelected(_predefinedAvatars[3]),
                      pointerPosition: _currentPointerPosition,
                      position: const Offset(229, 134),
                    ),
                    const SizedBox(width: 10),
                    // Avatar 5
                    _ImageCircle(
                      imageUrl: _predefinedAvatars[4],
                      size: 60,
                      isMain: false,
                      onTap: () => widget.onImageSelected(_predefinedAvatars[4]),
                      pointerPosition: _currentPointerPosition,
                      position: const Offset(299, 134),
                    ),
                    const SizedBox(width: 10),
                    // Upload custom image
                    _UploadCircle(
                      size: 60,
                      onTap: _pickImageFromGallery,
                      pointerPosition: _currentPointerPosition,
                      position: const Offset(369, 134),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual image circle with animation
class _ImageCircle extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final bool isMain;
  final VoidCallback? onTap;
  final Offset? pointerPosition;
  final Offset position;

  const _ImageCircle({
    required this.imageUrl,
    required this.size,
    required this.isMain,
    required this.onTap,
    required this.pointerPosition,
    required this.position,
  });

  @override
  State<_ImageCircle> createState() => _ImageCircleState();
}

class _ImageCircleState extends State<_ImageCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_ImageCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pointerPosition != null && !widget.isMain) {
      final pointerPos = widget.pointerPosition!;
      final circlePos = widget.position;
      
      // Check if pointer is within circle bounds
      if (pointerPos.dx >= circlePos.dx &&
          pointerPos.dx <= circlePos.dx + widget.size &&
          pointerPos.dy >= circlePos.dy &&
          pointerPos.dy <= circlePos.dy + widget.size) {
        if (_controller.status != AnimationStatus.forward &&
            _controller.status != AnimationStatus.completed) {
          _controller.forward();
        }
      } else {
        if (_controller.status != AnimationStatus.reverse &&
            _controller.status != AnimationStatus.dismissed) {
          _controller.reverse();
        }
      }
    } else if (widget.pointerPosition == null) {
      if (_controller.status != AnimationStatus.reverse &&
          _controller.status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE6E6E6),
        border: Border.all(
          color: widget.isMain ? const Color(0xFF8A5CF6) : const Color(0xFFE6E6E6),
          width: widget.isMain ? 3.0 : 2.0,
        ),
      ),
      child: ClipOval(
        child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFFC9C9C9),
                ),
              )
            : const Icon(
                Icons.person,
                size: 40,
                color: Color(0xFFC9C9C9),
              ),
      ),
    );

    if (widget.onTap == null) {
      return content;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: widget.isMain
          ? content
          : AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: content,
                );
              },
            ),
    );
  }
}

/// Upload button circle with animation
class _UploadCircle extends StatefulWidget {
  final double size;
  final VoidCallback onTap;
  final Offset? pointerPosition;
  final Offset position;

  const _UploadCircle({
    required this.size,
    required this.onTap,
    required this.pointerPosition,
    required this.position,
  });

  @override
  State<_UploadCircle> createState() => _UploadCircleState();
}

class _UploadCircleState extends State<_UploadCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_UploadCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pointerPosition != null) {
      final pointerPos = widget.pointerPosition!;
      final circlePos = widget.position;
      
      // Check if pointer is within circle bounds
      if (pointerPos.dx >= circlePos.dx &&
          pointerPos.dx <= circlePos.dx + widget.size &&
          pointerPos.dy >= circlePos.dy &&
          pointerPos.dy <= circlePos.dy + widget.size) {
        if (_controller.status != AnimationStatus.forward &&
            _controller.status != AnimationStatus.completed) {
          _controller.forward();
        }
      } else {
        if (_controller.status != AnimationStatus.reverse &&
            _controller.status != AnimationStatus.dismissed) {
          _controller.reverse();
        }
      }
    } else {
      if (_controller.status != AnimationStatus.reverse &&
          _controller.status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF8A5CF6),
                  width: 2.0,
                ),
              ),
              child: const Icon(
                Icons.add_photo_alternate_rounded,
                size: 30,
                color: Color(0xFF8A5CF6),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Full screen image viewer
class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
