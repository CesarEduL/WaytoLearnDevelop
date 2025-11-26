import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Usamos OrientationBuilder para confirmar la orientación
        return OrientationBuilder(
          builder: (context, orientation) {
            // Si el ancho es menor a 600 o estamos en portrait en un dispositivo pequeño
            if (constraints.maxWidth < 600 || orientation == Orientation.portrait) {
              return mobileBody;
            } 
            // Si el ancho es menor a 1100, usamos tablet si existe, sino desktop
            else if (constraints.maxWidth < 1100) {
              return tabletBody ?? desktopBody;
            } 
            // Pantallas grandes
            else {
              return desktopBody;
            }
          },
        );
      },
    );
  }
}
