import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLength;
  final bool? isObscure;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.validator,
    required this.onChanged,
    this.maxLength,
    this.isObscure,
    this.suffixIcon,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      obscureText: isObscure ?? false,
      onChanged: onChanged,
      validator: validator,
      keyboardType: textInputType,
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppTextTheme.regular,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
      ),
    );
  }
}
