import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/viewmodel/otp_view_model.dart';
import 'package:mobileapp/viewmodel/verify_otp_view_model.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class EnterOtpWidget extends StatefulWidget {
  final PageController pageController;
  const EnterOtpWidget({super.key, required this.pageController});

  @override
  State<EnterOtpWidget> createState() => _EnterOtpWidgetState();
}

class _EnterOtpWidgetState extends State<EnterOtpWidget> {
  TextEditingController textEditingController = TextEditingController();

  void viewModelListener() {
    if (!mounted) return;
    AppState appState = context.read<VerifyOtpViewModel>().appState;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appState == AppState.success) {
        widget.pageController.nextPage(
          duration: Durations.short3,
          curve: Curves.easeIn,
        );
      } else if (appState == AppState.error) {
        showToastMessage(
          message:
              context.read<VerifyOtpViewModel>().errorMessage ??
              "Something went wrong.",
        );
      }
      context.read<VerifyOtpViewModel>().resetState();
    });
  }

  @override
  void initState() {
    context.read<VerifyOtpViewModel>().addListener(viewModelListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OtpViewModel>().startCountDown();
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 36.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.pageController.previousPage(
                        duration: Durations.short3,
                        curve: Curves.easeIn,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
              Row(children: [Text("Enter OTP", style: AppTextTheme.semiBold)]),
              Row(),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            "Verify OTP, Sent on ${context.read<OtpViewModel>().phoneNumber}",
            style: AppTextTheme.medium,
          ),
          Pinput(
            controller: textEditingController,
            length: 4,
            keyboardType: TextInputType.number,
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            pinAnimationType: PinAnimationType.none,
          ),
          SizedBox(height: 24.h),
          Consumer<OtpViewModel>(
            builder: (context, value, child) {
              return Text(
                "00:${value.counter}",
                style: AppTextTheme.semiBoldThree,
              );
            },
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<VerifyOtpViewModel>(
                builder: (context, value, child) {
                  return value.appState == AppState.loading
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : Expanded(
                          child: CustomOutlinedButton(
                            buttonName: "Verify",
                            textStyle: AppTextTheme.semiBoldTwo,
                            color: Color(0xFF007BFF),
                            onPressed: () {
                              log(
                                "the number is ${context.read<OtpViewModel>().phoneNumber}",
                              );

                              value.verifyOtp(
                                enteredOtp: textEditingController.text,
                                mobileNumber:
                                    context.read<OtpViewModel>().phoneNumber ??
                                    "",
                              );
                            },
                            radius: 8.r,
                          ),
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
