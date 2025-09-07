import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_path.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/custom_text_form_field.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  final PageController pageController;
  const LoginWidget({super.key, required this.pageController});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late TextEditingController mobileNumberController;
  late TextEditingController passwordController;
  late ValueNotifier<bool> isObscure;
  late GlobalKey<FormState> globalKey;

  String dialCode = "+91";

  void viewModelListener() {
    if (!mounted) return;

    AppState appState = context.read<UserViewModel>().loginState;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appState == AppState.success) {
        Navigator.pushReplacementNamed(context, AppPath.homePage);
      } else if (appState == AppState.error) {
        showToastMessage(
          message:
              context.read<UserViewModel>().errorMessage ??
              "Something went wrong",
        );
      }
      context.read<UserViewModel>().resetLoginState();
    });
  }

  @override
  void initState() {
    context.read<UserViewModel>().addListener(viewModelListener);
    mobileNumberController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    passwordController = TextEditingController();
    isObscure = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    isObscure.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              SizedBox(height: 36.h),
              Text(
                "Please enter your credentials",
                style: AppTextTheme.semiBold,
              ),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Mobile Number", style: AppTextTheme.medium),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  SizedBox(
                    width: 95.w,
                    child: CountryCodePicker(
                      initialSelection: "IN",
                      textStyle: AppTextTheme.regular,
                      onChanged: (value) {
                        dialCode = value.dialCode ?? "+91";
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      controller: mobileNumberController,
                      maxLength: 10,
                      hintText: "Please enter your mobile no.",
                      textInputType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter your mobile number"
                          : null,
                      onChanged: null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Enter Password", style: AppTextTheme.medium),
              ),
              SizedBox(height: 6.h),
              ValueListenableBuilder(
                valueListenable: isObscure,
                builder: (context, value, child) {
                  return CustomTextFormField(
                    controller: passwordController,
                    isObscure: value,
                    hintText: "Enter password",
                    textInputType: TextInputType.text,
                    validator: (value) => value == null || value.isEmpty
                        ? "This field is required"
                        : null,
                    onChanged: null,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isObscure.value = !isObscure.value;
                      },
                      icon: Icon(
                        value ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password",
                      style: AppTextTheme.semiBoldThree,
                    ),
                  ),
                ],
              ),
              Consumer<UserViewModel>(
                builder: (context, value, child) {
                  return value.loginState == AppState.loading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : CustomOutlinedButton(
                          buttonName: "Sign in",
                          textStyle: AppTextTheme.semiBoldTwo,
                          color: Color(0xFF007BFF),
                          onPressed: () {
                            if (globalKey.currentState?.validate() ?? false) {
                              value.login(
                                mobileNumber:
                                    "$dialCode${mobileNumberController.text}",
                                password: passwordController.text,
                              );
                            }
                          },
                          radius: 8.r,
                        );
                },
              ),
              SizedBox(height: 22.h),
              TextButton(
                onPressed: () {
                  widget.pageController.jumpTo(0);
                },
                child: Text(
                  "New to CreditSea? Create an account",
                  style: AppTextTheme.semiBoldThree,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
