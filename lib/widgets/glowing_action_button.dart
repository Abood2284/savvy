import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

class GlowingActionButton extends StatelessWidget {
  const GlowingActionButton({
    Key? key,
    required this.color,
    required this.icon,
    this.size = 54,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.cardLight,
          customBorder: const CircleBorder(),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.9,
                  blurRadius: 25,
                  offset: const Offset(0, 5),
                  color: color.withOpacity(0.75),
                )
              ],
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white60,
                  color,
                ],
              ),
            ),
            height: size,
            width: size,
            child: Center(
                child: Transform.rotate(
              angle: math.pi / 4,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
