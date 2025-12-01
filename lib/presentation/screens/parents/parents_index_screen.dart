import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/parents/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/parents/children_list_box.dart';

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
    // Test data for children
    final testChildren = [
      const Child(
        childrenId: 'c_001',
        childrenName: 'Joel El terrible',
        childrenIcon: 'https://media.licdn.com/dms/image/v2/D4E35AQGmQpgptGqReQ/profile-framedphoto-shrink_800_800/B4EZloGNF7IUAg-/0/1758388081267?e=1765180800&v=beta&t=BwRZqnZ332ZzHdnSueS3G5Fu5RKZ2t6TWDtvu7LeGdE',
      ),
      const Child(
        childrenId: 'c_002',
        childrenName: 'Sofía Lima',
        childrenIcon: 'https://i.pravatar.cc/150?img=2',
      ),
    ];

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
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: ChildrenListBox(
              children: testChildren,
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
