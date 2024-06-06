import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Widget? targetView;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    this.targetView,
    this.onPressed,
    this.textStyle,
    this.borderSide,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        side: borderSide,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else if (targetView != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetView!),
          );
        }
      },
      child: Text(
        text,
        style: textStyle ??
            const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
      ),
    );
  }
}
