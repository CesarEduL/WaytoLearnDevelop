import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/screens/parents/parents_index_screen.dart';
import 'package:waytolearn/presentation/widgets/parents/back_icon_button.dart';
import 'package:waytolearn/presentation/widgets/parents/son_form_create.dart';
 

class AreaSonForm extends StatefulWidget {
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
            child: BackIconButton(
              onPressed: _goToParentsIndex,
            ),
          ),
          Positioned(
            top: 20,
            bottom: 20,
            left: 100,
            child: SonFormCreate(
              onCreateChild: _createChild,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createChild(String name, DateTime birthDate, String imageUrl) async {
    // TODO: Implement Firebase create functionality
    // This will create a new child with:
    // - name: child's name
    // - birthDate: child's birth date
    // - imageUrl: selected avatar URL
    
    // Example implementation:
    // try {
    //   await FirebaseFirestore.instance
    //     .collection('children')
    //     .add({
    //       'childrenName': name,
    //       'birthDate': birthDate,
    //       'childrenIcon': imageUrl,
    //       'createdAt': FieldValue.serverTimestamp(),
    //     });
    //   
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Niño creado exitosamente')),
    //     );
    //     _goToParentsIndex();
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Error al crear: $e')),
    //     );
    //   }
    // }
  }

  Future<void> _goToParentsIndex() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ParentsIndexScreen(),
      ),
    );
  }
}
