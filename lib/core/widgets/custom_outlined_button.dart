import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String buttonName;
  final Color color;
  final void Function()? onPressed;
  final double radius;
  final TextStyle? textStyle;
  const CustomOutlinedButton({
    super.key,
    required this.buttonName,
    required this.color,
    required this.onPressed,
    required this.radius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(358.w, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(radius),
        ),
      ),
      child: Text(buttonName, style: textStyle?.copyWith(color: Colors.white)),
    );
  }
}
