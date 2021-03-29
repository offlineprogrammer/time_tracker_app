import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double height;
  static const double borderRadius = 4.0;
  final VoidCallback onPressed;

  const CustomElevatedButton(
      {Key? key,
      required this.color,
      required this.onPressed,
      required this.child,
      this.height: 50})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        ),
        child: child,
      ),
    );
  }
}
