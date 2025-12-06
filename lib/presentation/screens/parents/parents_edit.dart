import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/screens/auth/auth_index.dart';
import 'package:waytolearn/presentation/widgets/auth/bear_register_icon.dart';
import 'package:waytolearn/presentation/widgets/auth/register_form_box.dart';
import 'package:waytolearn/presentation/widgets/parents/back_icon_button.dart';
import 'package:waytolearn/presentation/widgets/parents/parents_form_edit.dart';  
import 'package:waytolearn/presentation/widgets/parents/Bear_parents_icon.dart';



class  ParentsEdit extends StatefulWidget {
  const ParentsEdit({super.key});

  @override
  State<ParentsEdit> createState() => _ParentsEditState();
}

class _ParentsEditState extends State<ParentsEdit> {
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
            top: 20,
            left: 50,
            right: 350,
            child: ParentsFormEdit(
              
            ),
          ),
          Positioned(
            bottom: -10,
            left: 470,
            child: BearParentsIcon(),
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
