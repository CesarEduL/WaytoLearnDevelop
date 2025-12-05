import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/widgets/parents/home_icon_button.dart';
import 'package:waytolearn/presentation/screens/parents/parents_index_screen.dart';
  

class  AreaSonForm extends StatefulWidget {
  const AreaSonForm({super.key});

  @override
  State<AreaSonForm> createState() => _AreaSonFormState();
}

class _AreaSonFormState extends State<AreaSonForm> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -32,
            left: -17,
            child: HomeIconButton(
              onPressed: _goToDashboard,
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
        builder: (_) => const ParentsIndexScreen(),
      ),
    );
  }
}
