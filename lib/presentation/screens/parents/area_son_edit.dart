import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/widgets/parents/back_icon_button.dart';
import 'package:waytolearn/presentation/screens/parents/parents_index_screen.dart';
import 'package:waytolearn/presentation/widgets/parents/choose_image_box.dart';
import 'package:waytolearn/presentation/widgets/parents/children_list_box.dart';
import 'package:waytolearn/presentation/widgets/parents/info_children_box.dart';
import 'package:waytolearn/presentation/widgets/parents/save_button.dart';

  

class  AreaSonEdit extends StatefulWidget {
  final Child child;
  
  const AreaSonEdit({
    super.key,
    required this.child,
  });

  @override
  State<AreaSonEdit> createState() => _AreaSonEditState();
}

class _AreaSonEditState extends State<AreaSonEdit> {
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
              onPressed: _goToDashboard,
              backgroundColor: const Color(0xFFC8F65C), // Color personalizado opcional
            ),
          ),
          Positioned(
            top: 10,
            left: 200,
            child: ChooseImageBox(
              currentImageUrl: widget.child.childrenIcon,
              onImageSelected: (newImageUrl) {
                // Handle image selection
              },
            ),
          ),
          Positioned(
            top: 220,
            left: 235,
            child: InfoChildrenBox(childrenName: widget.child.childrenName, onNameChanged: (newName) {
              // Handle name change
            }, birthDate: widget.child.birthDate, onBirthDateChanged: (newDate) {
              // Handle birth date change
            },
          ),
          ),
          Positioned(
            top: 315,
            left: 350,
            child: SaveButton(
              onPressed: _saveChanges,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    // TODO: Implement Firebase save functionality
    // This will save the following data:
    // - Updated child name
    // - Updated child birth date
    // - Updated child image URL
    
    // Example implementation:
    // try {
    //   await FirebaseFirestore.instance
    //     .collection('children')
    //     .doc(widget.child.childrenId)
    //     .update({
    //       'childrenName': updatedName,
    //       'birthDate': updatedBirthDate,
    //       'childrenIcon': updatedImageUrl,
    //     });
    //   
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Cambios guardados exitosamente')),
    //     );
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Error al guardar: $e')),
    //     );
    //   }
    // }
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
