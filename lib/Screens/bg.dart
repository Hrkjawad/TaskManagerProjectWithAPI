import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class background extends StatelessWidget {
  const background({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/background.svg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        child
      ],
    );
  }
}
