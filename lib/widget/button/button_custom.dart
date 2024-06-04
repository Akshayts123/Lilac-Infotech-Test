import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final double height;
  final double? width;
  final Function()? onPressed;
  final Widget child;

  const CustomButton({
    Key? key,
    required this.color,
    required this.height,
    this.width,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 0, maxWidth: double.infinity),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height,
            minWidth: width ?? double.infinity,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
