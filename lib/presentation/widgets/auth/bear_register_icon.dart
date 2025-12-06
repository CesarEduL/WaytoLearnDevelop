import 'package:flutter/material.dart';

class BearRegisterIcon extends StatelessWidget {
  const BearRegisterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/auth_resources%2Fbear-icon-register.png?alt=media&token=8ee3d859-1e18-4689-93c2-e15354c55f1d',
      width: 400,
      height: 350,
      fit: BoxFit.contain,
    );
  }
}

