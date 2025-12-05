import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waytolearn/presentation/screens/auth/login_screen.dart';
import 'package:waytolearn/presentation/screens/auth/register_screen.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/auth/options_box.dart';
import 'package:waytolearn/presentation/widgets/parents/back_icon_button.dart';


class  AuthIndex extends StatefulWidget {
  const AuthIndex({super.key});

  @override
  State<AuthIndex> createState() => _AuthIndexState();
}

class _AuthIndexState extends State<AuthIndex> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFF8A5CF6),
      body: Stack(
        fit: StackFit.expand,

        children: [

          Positioned(
            top: -32,
            left: -17,
            child: BackIconButton(
              backgroundColor: const Color(0xFF8A5CF6),
              onPressed: _goToDashboard,
            ),
          ),
          Positioned(
            top: 110,
            left: 23,
            child: Text(
              "Way to Learn",
              style: GoogleFonts.mysteryQuest(
                fontSize: 85,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 530,
            child: OptionsBox(
              onHaveAccountTap: _goToLogin,
              onNoAccountTap: _goToRegister,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToDashboard() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }
  Future<void> _goToLogin() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }
  Future<void> _goToRegister() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }
}
