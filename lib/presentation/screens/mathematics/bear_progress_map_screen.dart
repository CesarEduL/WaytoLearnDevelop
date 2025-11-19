import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/session_progress_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/communication_switch_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/mathematics_bottom_bot.dart';

class BearProgressMapScreen extends StatefulWidget {
  const BearProgressMapScreen({super.key});

  @override
  State<BearProgressMapScreen> createState() => _BearProgressMapScreenState();
}

class _BearProgressMapScreenState extends State<BearProgressMapScreen> {


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const designWidth = 912.0;
    final scale = mediaSize.width / designWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [

          Positioned(
              top: -32,
              left: -17,
              child: HomeIconButton(
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 14 * scale,
              left: 806 * scale,
              child: CommunicationSwitchButton(
                onTap: _openCommunication,
                scale: scale,
              ),
            ),

            // Bot de comunicación
            Positioned(
              top: 345 * scale,
              left: 830 * scale,
              child: MathematicsBottomBot(
                scale: scale,
              ),
            ),

          ],
        ),
    );
  }

  Future<void> _openCommunication() async {
    await OrientationService().setLandscapeOnly();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SessionProgressScreen(),
      ),
    );
  }
}
