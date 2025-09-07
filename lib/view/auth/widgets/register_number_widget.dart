import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_text_form_field.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/viewmodel/otp_view_model.dart';
import 'package:provider/provider.dart';

class RegisterNumberWidget extends StatefulWidget {
  final PageController pageController;
  const RegisterNumberWidget({super.key, required this.pageController});

  @override
  State<RegisterNumberWidget> createState() => _RegisterNumberWidgetState();
}

class _RegisterNumberWidgetState extends State<RegisterNumberWidget> {
  late TextEditingController _mobileNumberController;

  late ValueNotifier<bool> isAgreed;

  late GlobalKey<FormState> globalKey;

  void viewModelListener() {
    if (!mounted) return;
    AppState appState = context.read<OtpViewModel>().appState;

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (appState == AppState.success) {
        widget.pageController.nextPage(
          duration: Durations.short3,
          curve: Curves.easeIn,
        );
      } else if (appState == AppState.error) {
        showToastMessage(
          message:
              context.read<OtpViewModel>().errorMessage ??
              "Something went wrong",
        );
      }
      context.read<OtpViewModel>().resetState();
    });
  }

  @override
  void initState() {
    isAgreed = ValueNotifier(true);
    context.read<OtpViewModel>().addListener(viewModelListener);
    _mobileNumberController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    isAgreed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 26.h),
          Text("Welcome to Credit Sea!", style: AppTextTheme.semiBold),
          SizedBox(height: 18.h),
          Align(
            alignment: Alignment.topLeft,
            child: Text("Mobile Number", style: AppTextTheme.medium),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10.w,
            children: [
              SizedBox(
                width: 95.w,
                child: CountryCodePicker(
                  initialSelection: "IN",
                  textStyle: AppTextTheme.regular,
                  onChanged: (value) {
                    context.read<OtpViewModel>().setCountryCode(
                      value.dialCode ?? "",
                    );
                  },
                ),
              ),
              Expanded(
                child: Form(
                  key: globalKey,
                  child: CustomTextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 10,
                    onChanged: (value) {
                      context.read<OtpViewModel>().setPhoneNumber(value);
                    },
                    controller: _mobileNumberController,
                    hintText: "Please enter your mobile no.",
                    textInputType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter your mobile no"
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isAgreed,
                builder: (context, value, child) {
                  return Checkbox(
                    value: value,
                    onChanged: (value) {
                      isAgreed.value = value ?? false;
                    },
                  );
                },
              ),
              Expanded(
                child: Text(
                  "By continuing, you agree to our privacy policies and Terms & Conditions.",
                  style: AppTextTheme.mediumTwo,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Consumer<OtpViewModel>(
            builder: (context, value, child) {
              return OutlinedButton(
                onPressed: value.appState == AppState.loading
                    ? null
                    : () {
                        if (!isAgreed.value) {
                          showToastMessage(
                            message: "Please agree to terms and conditions",
                          );
                          return;
                        }
                        if (globalKey.currentState?.validate() ?? false) {
                          value.sendOtp(
                            mobileNumber:
                                context.read<OtpViewModel>().phoneNumber ?? "",
                          );
                        }
                      },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFF007BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  minimumSize: Size(358.w, 50.h),
                ),
                child: value.appState == AppState.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : Text(
                        "Request OTP",
                        style: AppTextTheme.semiBoldTwo.copyWith(
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
          TextButton(
            onPressed: () {
              widget.pageController.jumpToPage(3);
            },
            child: Text(
              "Existing User? Sign in",
              style: AppTextTheme.semiBoldThree,
            ),
          ),
        ],
      ),
    );
  }
}
