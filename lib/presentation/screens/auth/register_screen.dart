import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waytolearn/presentation/screens/auth/auth_index.dart';
import 'package:waytolearn/presentation/widgets/parents/back_icon_button.dart';
import 'package:waytolearn/presentation/widgets/auth/login_form_box.dart';


class  RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
              onPressed: _goToAuthIndex,
            ),
          ),
          Positioned(
            top: 20,
            left: 150,
            right: 150,
            child: LoginFormBox(
              
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToAuthIndex() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthIndex(),
      ),
    );
  }
}
