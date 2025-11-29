import 'package:flutter/material.dart';

class UserInfoBox extends StatelessWidget {
  final String childrenName;
  final String? childrenIcon;
  

  const UserInfoBox({
    super.key,
    required this.childrenName,
    this.childrenIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 254,
      height: 39,
      child: Stack(
        children: [
          // Contenedor de texto sin relleno
          Positioned(
            left: 0,
            top: 7,
            child: SizedBox(
              width: 200,
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hola, ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFFF68A5C),
                      ),
                    ),
                    TextSpan(
                      text: childrenName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8A5CF6),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    TextSpan(
                      text: '\n¿Qué vamos a aprender hoy?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFF65C7B),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenedor circular con imagen de perfil
          Positioned(
            left: 213,
            top: 0,
            child: ClipOval(
              child: Container(
                width: 41,
                height: 39,
                child: Image.network(
                  childrenIcon ?? 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fuser-icon.png?alt=media&token=a30fa4a4-5f1c-4fc7-ab64-67828ed0fdb1',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
