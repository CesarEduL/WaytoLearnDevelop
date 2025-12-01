import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/parents/home_icon_button.dart';

class  ParentsIndexScreen extends StatefulWidget {
  const ParentsIndexScreen({super.key});

  @override
  State<ParentsIndexScreen> createState() => _ParentsIndexScreenState();
}

class _ParentsIndexScreenState extends State<ParentsIndexScreen> {
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
        builder: (_) => const DashboardScreen(),
      ),
    );
  }
}
