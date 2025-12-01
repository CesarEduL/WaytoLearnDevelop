import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:waytolearn/presentation/screens/parents/parents_index_screen.dart';
// ============================================================================
// MODELO DE DATOS - Opción del menú
// ============================================================================
class MenuOption {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// ============================================================================
// CONSTANTES DE DISEÑO - Centralización de estilos
// ============================================================================
class _MenuConstants {
  // Duraciones de animación
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration expandDuration = Duration(milliseconds: 200);
  
  // Blur y overlay
  static const double blurSigma = 8.0;
  static const double overlayOpacity = 0.4;
  
  // Dimensiones
  static const double menuWidth = 360.0;
  static const double menuBorderRadius = 20.0;
  static const double itemHeight = 64.0;
  static const double iconSize = 42.0;
  static const double closeButtonSize = 54.0;
  
  // Espaciados
  static const EdgeInsets itemPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  static const double itemIconTextGap = 16.0;
  static const double menuOffsetX = 160.0;
  static const double menuOffsetY = 10.0;
  
  // Elevaciones y sombras
  static const double menuElevation = 20.0;
  static const double hoverScale = 1.03;
  static const double pressScale = 0.98;
  
  // Colores
  static const Color buttonColor = Color(0xFF8397BE);
  static const Color closeButtonColor = Color(0xFF2A1E96);
}

// ============================================================================
// WIDGET PRINCIPAL - MenuIconDropdown (Escalable y Modular)
// ============================================================================
/// Widget modular que muestra un menú desplegable con blur overlay
/// 
/// Uso básico (3 opciones por defecto):
/// ```dart
/// MenuIconDropdown()
/// ```
/// 
/// Uso avanzado (N opciones personalizadas):
/// ```dart
/// MenuIconDropdown(
///   options: [
///     MenuOption(
///       title: 'Perfil',
///       icon: Icons.person,
///       color: Colors.blue,
///       onTap: () => Navigator.push(...),
///     ),
///     MenuOption(
///       title: 'Configuración',
///       icon: Icons.settings,
///       color: Colors.grey,
///       onTap: () => showDialog(...),
///     ),
///   ],
/// )
/// ```
class MenuIconDropdown extends StatefulWidget {
  final String? iconUrl;
  final List<MenuOption>? options;
  final VoidCallback? onMenuClosed;

  const MenuIconDropdown({
    super.key,
    this.iconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fmenu-icon.svg?alt=media&token=15587218-982a-4272-a7b0-7e30f1df119d',
    this.options,
    this.onMenuClosed,
  });

  @override
  State<MenuIconDropdown> createState() => _MenuIconDropdownState();
}

class _MenuIconDropdownState extends State<MenuIconDropdown> {
  bool _isPressed = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();

  // ====== Opciones por defecto ======
  
  List<MenuOption> get _menuOptions => widget.options ?? [
    MenuOption(
      title: 'Tu hijo',
      icon: Icons.child_care_rounded,
      color: const Color(0xFF8A5CF6),
      onTap: () => _showDevelopmentMessage('Tu hijo', const Color(0xFF8A5CF6)),
    ),
    MenuOption(
      title: 'Informes de progreso',
      icon: Icons.assessment_rounded,
      color: const Color(0xFF5CF6D7),
      onTap: () => _showDevelopmentMessage('Informes de progreso', const Color(0xFF5CF6D7)),
    ),
    MenuOption(
      title: 'Área de padres',
      icon: Icons.family_restroom_rounded,
      color: const Color(0xFFF68A5C),
      onTap: _navigateToParentsIndex,
    ),
  ];

  void _showDevelopmentMessage(String section, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text('Pantalla en desarrollo: $section'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _navigateToParentsIndex() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ParentsIndexScreen(),
      ),
    );
  }

  // ====== Métodos de control del Overlay ======
  
  void _showMenuOverlay() {
    if (_overlayEntry != null) return;

    final RenderBox? renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _MenuOverlayWidget(
        buttonPosition: position,
        buttonSize: renderBox.size,
        iconUrl: widget.iconUrl!,
        options: _menuOptions,
        onClose: _closeMenuOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeMenuOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onMenuClosed?.call();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _showMenuOverlay();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: _MenuButton(
        isPressed: _isPressed,
        iconUrl: widget.iconUrl!,
      ),
    );
  }
}

// ============================================================================
// BOTÓN DEL MENÚ - Componente reutilizable
// ============================================================================
class _MenuButton extends StatelessWidget {
  final bool isPressed;
  final String iconUrl;

  const _MenuButton({
    required this.isPressed,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.21,
      height: 106.16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: _MenuConstants.buttonColor,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 50,
            child: AnimatedScale(
              scale: isPressed ? 2.0 : 1.0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutBack,
              child: SizedBox(
                width: 39,
                height: 36,
                child: SvgPicture.network(
                  iconUrl,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// OVERLAY WIDGET - Blur + Menú + Botón X
// ============================================================================
class _MenuOverlayWidget extends StatefulWidget {
  final Offset buttonPosition;
  final Size buttonSize;
  final String iconUrl;
  final List<MenuOption> options;
  final VoidCallback onClose;

  const _MenuOverlayWidget({
    required this.buttonPosition,
    required this.buttonSize,
    required this.iconUrl,
    required this.options,
    required this.onClose,
  });

  @override
  State<_MenuOverlayWidget> createState() => _MenuOverlayWidgetState();
}

class _MenuOverlayWidgetState extends State<_MenuOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: _MenuConstants.animationDuration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  void _handleOptionTap(VoidCallback callback) {
    callback();
    _handleClose();
  }

  @override
  Widget build(BuildContext context) {
    final menuLeft = widget.buttonPosition.dx - 
        (_MenuConstants.menuWidth - widget.buttonSize.width) / 2 + 
        _MenuConstants.menuOffsetX;
    final menuTop = widget.buttonPosition.dy + 
        widget.buttonSize.height + 
        _MenuConstants.menuOffsetY;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blur backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleClose,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _MenuConstants.blurSigma,
                    sigmaY: _MenuConstants.blurSigma,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(_MenuConstants.overlayOpacity),
                  ),
                ),
              ),
            ),
          ),

          // Botón visible sobre el blur
          Positioned(
            left: widget.buttonPosition.dx,
            top: widget.buttonPosition.dy,
            child: IgnorePointer(
              child: _MenuButton(
                isPressed: false,
                iconUrl: widget.iconUrl,
              ),
            ),
          ),

          // Botón X
          Positioned(
            top: 20,
            right: 20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _CloseButton(onTap: _handleClose),
              ),
            ),
          ),

          // Panel de menú
          Positioned(
            left: menuLeft,
            top: menuTop,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _MenuPanel(
                    options: widget.options,
                    onOptionTap: _handleOptionTap,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTÓN DE CIERRE - X animado
// ============================================================================
class _CloseButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: _MenuConstants.expandDuration,
        width: _MenuConstants.closeButtonSize,
        height: _MenuConstants.closeButtonSize,
        decoration: BoxDecoration(
          color: _MenuConstants.closeButtonColor,
          borderRadius: BorderRadius.circular(_MenuConstants.closeButtonSize / 2),
          boxShadow: [
            BoxShadow(
              color: _MenuConstants.closeButtonColor.withOpacity(0.4),
              blurRadius: _isPressed ? 20 : 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: AnimatedRotation(
          duration: _MenuConstants.expandDuration,
          turns: _isPressed ? 0.125 : 0.0,
          child: AnimatedScale(
            duration: _MenuConstants.expandDuration,
            scale: _isPressed ? 0.9 : 1.0,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PANEL DE MENÚ - Container con opciones dinámicas
// ============================================================================
class _MenuPanel extends StatelessWidget {
  final List<MenuOption> options;
  final Function(VoidCallback) onOptionTap;

  const _MenuPanel({
    required this.options,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _MenuConstants.menuWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_MenuConstants.menuBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: _MenuConstants.menuElevation,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_MenuConstants.menuBorderRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            options.length,
            (index) => Column(
              children: [
                _MenuItem(
                  option: options[index],
                  onTap: () => onOptionTap(options[index].onTap),
                ),
                if (index < options.length - 1) const _Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ITEM DE MENÚ - Opción individual con animaciones
// ============================================================================
class _MenuItem extends StatefulWidget {
  final MenuOption option;
  final VoidCallback onTap;

  const _MenuItem({
    required this.option,
    required this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _currentScale {
    if (_isPressed) return _MenuConstants.pressScale;
    if (_isHovered) return _MenuConstants.hoverScale;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          duration: _MenuConstants.expandDuration,
          scale: _currentScale,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: _MenuConstants.expandDuration,
            height: _MenuConstants.itemHeight,
            padding: _MenuConstants.itemPadding,
            decoration: BoxDecoration(
              color: (_isHovered || _isPressed)
                  ? widget.option.color.withOpacity(0.08)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: _MenuConstants.expandDuration,
                  width: _MenuConstants.iconSize,
                  height: _MenuConstants.iconSize,
                  decoration: BoxDecoration(
                    color: (_isHovered || _isPressed)
                        ? widget.option.color.withOpacity(0.2)
                        : widget.option.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.option.icon,
                    size: 24,
                    color: widget.option.color,
                  ),
                ),
                SizedBox(width: _MenuConstants.itemIconTextGap),
                Expanded(
                  child: Text(
                    widget.option.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: (_isHovered || _isPressed)
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: const Color(0xFF2A1E96),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: _MenuConstants.expandDuration,
                  opacity: _isHovered ? 1.0 : 0.0,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: widget.option.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DIVISOR - Línea separadora entre opciones
// ============================================================================
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: const Color(0xFFE8E8E8),
    );
  }
}

// ============================================================================
// ALIAS PARA COMPATIBILIDAD
// ============================================================================
/// Alias del widget principal para mantener compatibilidad
typedef MenuIconButton = MenuIconDropdown;