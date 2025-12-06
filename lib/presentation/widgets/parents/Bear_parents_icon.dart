import 'package:flutter/material.dart';

class BearParentsIcon extends StatelessWidget {
  const BearParentsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/auth_resources%2Fbear_edit_parents_icon.png?alt=media&token=76336274-673b-4fb3-bf2c-a7eded93108b',
      width: 400,
      height: 350,
      fit: BoxFit.contain,
    );
  }
}
