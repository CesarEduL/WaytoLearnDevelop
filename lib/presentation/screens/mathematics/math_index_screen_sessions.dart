import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class MathIndexScreenSessions extends StatefulWidget {
  const MathIndexScreenSessions({super.key});

  @override
  State<MathIndexScreenSessions> createState() => _MathIndexScreenSessionsState();
}

class _MathIndexScreenSessionsState extends State<MathIndexScreenSessions> {
  static final Future<String> _homeIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fhome-icon.svg?alt=media&token=38f6113e-7be1-4f7d-8490-c08f8a83abfa',
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

          ],
        ),
    );
  }
}
