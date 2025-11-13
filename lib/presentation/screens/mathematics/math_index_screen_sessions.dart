import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/session_progress_screen.dart';

class MathIndexScreenSessions extends StatefulWidget {
  const MathIndexScreenSessions({super.key});

  @override
  State<MathIndexScreenSessions> createState() => _MathIndexScreenSessionsState();
}

class _MathIndexScreenSessionsState extends State<MathIndexScreenSessions> {
  static final Future<String> _homeIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fhome-icon.svg?alt=media&token=38f6113e-7be1-4f7d-8490-c08f8a83abfa',
  );
  static final Future<String> _communicationIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fcomunication-icon-switch.svg?alt=media&token=b014d9af-ee54-4e4b-bdc9-6f077ca4226a',
  );

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

            const Center(
              child: Text(
                '¡Hola, mundo!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEC4899),
                ),
              ),
            ),

            Positioned(
              top: -32,
              left: -17,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(
                  width: 100.21,
                  height: 111.16,
                  child: FutureBuilder<String>(
                    future: _homeIconFuture,
                    builder: (context, snapshot) {
                      final isIconReady =
                          snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Círculo de fondo
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8397BE),
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                          ),
                          if (isIconReady)
                            Positioned(
                              left: 40,
                              top: 57,
                              child: SizedBox(
                                width: 29,
                                height: 26,
                                child: SvgPicture.network(
                                  snapshot.data!,
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (context) => const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          if (!isIconReady)
                            const Positioned(
                              left: 35,
                              top: 43,
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.home,
                                  size: 20,
                                  color: Color(0xFFEC4899),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 14 * scale,
              left: 806 * scale,
              child: SizedBox(
                width: 83.33 * scale,
                height: 40 * scale,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CF6D7),
                          borderRadius: BorderRadius.circular(20 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x8000C7AF),
                              offset: Offset(0, 6 * scale),
                              blurRadius: 12 * scale,
                            ),
                            BoxShadow(
                              color: const Color(0x4D00C7AF),
                              offset: Offset(0, 2 * scale),
                              blurRadius: 6 * scale,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: (862 - 856) * scale,
                      top: (27 - 24) * scale,
                      child: GestureDetector(
                        onTap: _openCommunication,
                        child: SizedBox(
                          width: 36 * scale,
                          height: 33 * scale,
                          child: FutureBuilder<String>(
                            future: _communicationIconFuture,
                            builder: (context, snapshot) {
                              final isReady = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9C74F2),
                                  borderRadius: BorderRadius.circular(20 * scale),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x66000000),
                                      offset: Offset(0, 4 * scale),
                                      blurRadius: 6 * scale,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: isReady
                                    ? SvgPicture.network(
                                        snapshot.data!,
                                        fit: BoxFit.contain,
                                        placeholderBuilder: (context) => const SizedBox.shrink(),
                                      )
                                    : Icon(
                                        Icons.chat_bubble,
                                        size: 18 * scale,
                                        color: Colors.white,
                                      ),
                              );
                            },
                          ),
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
