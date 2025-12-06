import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waytolearn/presentation/screens/auth/auth_index.dart';
import 'package:waytolearn/presentation/widgets/auth/login_form_box.dart';
import 'package:waytolearn/presentation/widgets/parents/back_icon_button.dart';


class  LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFF8A5CF6),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
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
                top: 10,
                left: 150,
                right: 150,
                child: LoginFormBox(
                  
                ),
              ),
            ],
          ),
        ),
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
