import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/custom_text_form_field.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/viewmodel/otp_view_model.dart';
import 'package:mobileapp/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class CreatePasswordWidget extends StatefulWidget {
  final PageController pageController;
  const CreatePasswordWidget({super.key, required this.pageController});

  @override
  State<CreatePasswordWidget> createState() => _CreatePasswordWidgetState();
}

class _CreatePasswordWidgetState extends State<CreatePasswordWidget> {
  late TextEditingController passwordController;

  late TextEditingController confirmPasswordController;

  late ValueNotifier<bool> isPasswordObscure;
  late ValueNotifier<bool> isConfirmPasswordObscure;

  late GlobalKey<FormState> globalKey;

  void viewModelListener() async {
    if (!mounted) return;
    AppState appState = context.read<UserViewModel>().appState;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appState == AppState.success) {
        widget.pageController.nextPage(
          duration: Durations.short3,
          curve: Curves.easeIn,
        );
      } else if (appState == AppState.error) {
        showToastMessage(
          message:
              context.read<UserViewModel>().errorMessage ??
              "Something went wrong",
        );
      }
      context.read<UserViewModel>().resetState();
    });
  }

  @override
  void initState() {
    context.read<UserViewModel>().addListener(viewModelListener);
    globalKey = GlobalKey<FormState>();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    isPasswordObscure = ValueNotifier(true);
    isConfirmPasswordObscure = ValueNotifier(true);

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    isPasswordObscure.dispose();
    isConfirmPasswordObscure.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: globalKey,
        child: Column(
          children: [
            SizedBox(height: 36.h),
            Text("Create a password", style: AppTextTheme.semiBold),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Enter Password", style: AppTextTheme.medium),
            ),
            SizedBox(height: 6.h),
            ValueListenableBuilder(
              valueListenable: isPasswordObscure,
              builder: (context, value, child) {
                return CustomTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  hintText: "Enter password",
                  textInputType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please create a password"
                      : null,
                  onChanged: null,
                  isObscure: isPasswordObscure.value,
                  suffixIcon: IconButton(
                    onPressed: () {
                      isPasswordObscure.value = !isPasswordObscure.value;
                    },
                    icon: Icon(value ? Icons.visibility : Icons.visibility_off),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Re enter password", style: AppTextTheme.medium),
            ),
            SizedBox(height: 6.h),
            ValueListenableBuilder(
              valueListenable: isConfirmPasswordObscure,
              builder: (context, value, child) {
                return CustomTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: confirmPasswordController,
                  hintText: "Enter password",
                  textInputType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter confirm password"
                      : value == passwordController.text
                      ? null
                      : "Password and confirm password should match",
                  onChanged: null,
                  isObscure: isConfirmPasswordObscure.value,
                  suffixIcon: IconButton(
                    onPressed: () {
                      isConfirmPasswordObscure.value =
                          !isConfirmPasswordObscure.value;
                    },
                    icon: Icon(value ? Icons.visibility : Icons.visibility_off),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            Text(
              "*your password must include at least 8 characters, inclusive of alt least 1 special character",
              style: AppTextTheme.semiBoldThree.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Consumer<UserViewModel>(
                  builder: (context, value, child) {
                    return value.appState == AppState.loading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : Expanded(
                            child: CustomOutlinedButton(
                              buttonName: "Proceed",
                              textStyle: AppTextTheme.semiBoldTwo,
                              color: Color(0xFF007BFF),
                              onPressed: () {
                                if (globalKey.currentState?.validate() ??
                                    false) {
                                  value.createAccount(
                                    mobileNumber:
                                        context
                                            .read<OtpViewModel>()
                                            .phoneNumber ??
                                        "",
                                    password: passwordController.text,
                                  );
                                }
                              },
                              radius: 8.r,
                            ),
                          );
                  },
                ),
              ],
            ),
            SizedBox(height: 23.h),
          ],
        ),
      ),
    );
  }
}
