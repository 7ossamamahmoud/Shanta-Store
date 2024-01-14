import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final void Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ),
        color: Colors.white.withOpacity(
          0.07,
        ),
      ),
      child: IconButton(
        enableFeedback: true,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 28,
        ),
      ),
    );
  }
}
