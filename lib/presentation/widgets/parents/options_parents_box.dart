import 'package:flutter/material.dart';

class OptionsParentsBox extends StatelessWidget {
  const OptionsParentsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Container principal
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF8A5CF6),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // Icon Container
          Positioned(
            left: 39,
            top: 10,
            child: Container(
              width: 92,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          // Name Option Container
          Positioned(
            left: 12,
            top: 90,
            child: Container(
              width: 146,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
