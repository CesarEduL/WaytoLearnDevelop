import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/screens/communication/comm_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/mathematics/math_index_screen_sessions.dart';
import 'package:waytolearn/presentation/widgets/main/menu_icon_button.dart';
import 'package:waytolearn/presentation/widgets/main/subject_comm_box_widget.dart';
import 'package:waytolearn/presentation/widgets/main/subject_math_box_widget.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // GlobalKeys para detectar posición de cada widget
  final GlobalKey _commBoxKey = GlobalKey();
  final GlobalKey _mathBoxKey = GlobalKey();

  // Estados de hover
  bool _commBoxHovered = false;
  bool _mathBoxHovered = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerMove: (event) => _handlePointerMove(event.position),
        onPointerUp: (_) => _resetAllHovers(),
        onPointerCancel: (_) => _resetAllHovers(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -32,
              left: -18,
              child: MenuIconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pantalla en desarrollo'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 78,
              left: 28,
              child: Text (
                'Materias',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF2A1E96),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 28,
              child: SubjectCommBoxWidget(
                currentSession: 'Sesión 01',
                key: _commBoxKey,
                isHovered: _commBoxHovered,
                onTap: () {
                    Navigator.of(context).push(
                    MaterialPageRoute<void>(
                    builder: (context) => const CommIndexScreenSessions(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 100,
              left: 425,
              child: SubjectMathBoxWidget(
                currentSession: 'Sesión 01',
                key: _mathBoxKey,
                isHovered: _mathBoxHovered,
                onTap: () {
                    Navigator.of(context).push(
                    MaterialPageRoute<void>(
                    builder: (context) => const MathIndexScreenSessions(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 239,
              left: 28,
              child: Text (
                'Logros',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF2A1E96),
                ),
              ),
            ),


            Positioned(
              top: 239,
              left: 728,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pantalla en desarrollo'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF2A1E96),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePointerMove(Offset globalPosition) {
    bool commInside = _isPointerInside(_commBoxKey, globalPosition);
    bool mathInside = _isPointerInside(_mathBoxKey, globalPosition);

    if (_commBoxHovered != commInside || _mathBoxHovered != mathInside) {
      setState(() {
        _commBoxHovered = commInside;
        _mathBoxHovered = mathInside;
      });
    }
  }

  bool _isPointerInside(GlobalKey key, Offset globalPosition) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;

    final Offset localPosition = box.globalToLocal(globalPosition);
    return box.paintBounds.contains(localPosition);
  }

  void _resetAllHovers() {
    setState(() {
      _commBoxHovered = false;
      _mathBoxHovered = false;
    });
  }
}
