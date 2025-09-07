import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';

Widget stepWidget({
  required int index,
  required String title,
  required bool isSelected,
}) {
  return GestureDetector(
    onTap: () {},
    child: Row(
      spacing: 8.w,
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: isSelected ? Color(0xFF007BFF) : null,
          child: Center(
            child: Text(
              index.toString(),
              style: AppTextTheme.mediumTwo.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        Text(title, style: AppTextTheme.semiBold.copyWith(fontSize: 12.sp)),
      ],
    ),
  );
}
