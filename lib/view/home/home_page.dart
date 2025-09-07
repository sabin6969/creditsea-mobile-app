import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_asset_path.dart';
import 'package:mobileapp/core/constants/app_path.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/extensions/string_extension.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/custom_text_form_field.dart';
import 'package:mobileapp/core/widgets/step_widget.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/viewmodel/user_view_model.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> genders = ["MALE", "FEMALE", "OTHER"];
  List<String> maritalStatusList = ["MARRIED", "UNMARRIED"];

  late ValueNotifier<String?> selectedGender;
  late ValueNotifier<int?> dateOfBirth;

  late ValueNotifier<String?> maritalStatus;

  late TextEditingController firstNameController;

  late TextEditingController lastNameController;

  late GlobalKey<FormState> globalKey;

  late PageController pageController;

  late TextEditingController emailController;

  late TextEditingController panController;

  void viewModelListener() {
    if (!mounted) return;

    AppState appState = context.read<UserViewModel>().updateUserState;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appState == AppState.success) {
        showToastMessage(message: "Successfully updated details");
        if (context.read<UserViewModel>().isLastStep) {
          Navigator.pushReplacementNamed(context, AppPath.calculatorPage);
        } else {
          pageController.nextPage(
            duration: Durations.short3,
            curve: Curves.easeIn,
          );
        }
      } else if (appState == AppState.error) {
        showToastMessage(
          message:
              context.read<UserViewModel>().errorMessage ??
              "Something went wrong",
        );
      }
    });
  }

  @override
  void initState() {
    context.read<UserViewModel>().addListener(viewModelListener);
    firstNameController = TextEditingController();
    pageController = PageController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    panController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    selectedGender = ValueNotifier(null);
    dateOfBirth = ValueNotifier(null);
    maritalStatus = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    selectedGender.dispose();
    pageController.dispose();
    dateOfBirth.dispose();
    emailController.dispose();
    maritalStatus.dispose();
    panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 52.w,
            children: [
              stepWidget(index: 1, title: "Register", isSelected: true),
              stepWidget(index: 2, title: "Offer", isSelected: false),
              stepWidget(index: 3, title: "Approval", isSelected: false),
            ],
          ),
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        constraints: BoxConstraints(minWidth: double.infinity),
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
        ),
        enableDrag: false,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              border: Border.all(color: Colors.black, width: 0.4.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: globalKey,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: [
                          updateUserDetailWidget(),
                          updateEmailWidget(),
                          verifyPANWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget updateUserDetailWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personal Details", style: AppTextTheme.semiBold),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("First Name*", style: AppTextTheme.semiBoldThree),
              Text("Last Name*", style: AppTextTheme.semiBoldThree),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: CustomTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: firstNameController,
                  hintText: "Your first name",
                  textInputType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty
                      ? "First name is required"
                      : null,
                  onChanged: null,
                ),
              ),
              Expanded(
                child: CustomTextFormField(
                  controller: lastNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hintText: "Your first name",
                  textInputType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty
                      ? "Last name is required"
                      : null,
                  onChanged: null,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text("Gender*", style: AppTextTheme.semiBoldThree),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: selectedGender,
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      isExpanded: true,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: Text("Select your gender"),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please select your gender"
                          : null,
                      value: value,
                      items: genders
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectedGender.value = value ?? "MALE";
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text("Date of Birth*", style: AppTextTheme.semiBoldThree),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 0.4)),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: dateOfBirth,
                      builder: (context, value, child) {
                        return value == null
                            ? Text("DD-MM-YY")
                            : Text(
                                "${DateTime.fromMillisecondsSinceEpoch(value).day}-${DateTime.fromMillisecondsSinceEpoch(value).month}-${DateTime.fromMillisecondsSinceEpoch(value).year}",
                              );
                      },
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    DateTime? time = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now(),
                    );
                    dateOfBirth.value = time?.millisecondsSinceEpoch;
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text("Your marital status*", style: AppTextTheme.semiBoldThree),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: maritalStatus,
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please select your marital status"
                          : null,
                      isExpanded: true,
                      hint: Text("Select"),
                      value: value,
                      items: maritalStatusList
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        maritalStatus.value = value ?? "MARRIED";
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 80.h),
          Consumer<UserViewModel>(
            builder: (context, value, child) {
              return value.updateUserState == AppState.loading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : CustomOutlinedButton(
                      buttonName: "Continue",
                      textStyle: AppTextTheme.semiBoldThree,
                      color: Color(0xFF007BFF),
                      onPressed: () {
                        if (globalKey.currentState?.validate() ?? false) {
                          if (dateOfBirth.value == null) {
                            showToastMessage(
                              message: "Please select your date of birth",
                            );
                            return;
                          }
                          value.updateUserDetails(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            gender: selectedGender.value ?? "",
                            dateOfBirth: dateOfBirth.value ?? 0,
                            maritalStatus: maritalStatus.value ?? "",
                          );
                        }
                      },
                      radius: 8.r,
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget updateEmailWidget() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20.w,
              children: [
                IconButton(
                  onPressed: () {
                    pageController.previousPage(
                      duration: Durations.short3,
                      curve: Curves.easeIn,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text("Personal Email Id", style: AppTextTheme.semiBold),
              ],
            ),
            SizedBox(height: 32.h),
            Center(
              child: Image.asset(
                AppAssetPath.emailImage,
                height: 170.h,
                width: 170.w,
              ),
            ),
            SizedBox(height: 32.h),
            Text("Email id*", style: AppTextTheme.semiBoldThree),
            SizedBox(height: 12.h),
            CustomTextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              hintText: "Enter your email id",
              textInputType: TextInputType.emailAddress,
              validator: (value) => value == null || value.isEmpty
                  ? "Please enter your email"
                  : !value.isValidEmail
                  ? "Please enter valid email"
                  : null,
              onChanged: null,
            ),
            SizedBox(height: 24.h),
            Text("OTP Verification*", style: AppTextTheme.semiBoldThree),
            SizedBox(height: 12.h),
            Pinput(length: 6),
            Row(
              children: [
                Text("Didn't receive code?"),
                TextButton(onPressed: () {}, child: const Text("Resend Code")),
              ],
            ),
            SizedBox(height: 30.h),
            Consumer<UserViewModel>(
              builder: (context, value, child) {
                return value.updateUserState == AppState.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : CustomOutlinedButton(
                        buttonName: "Verify",
                        textStyle: AppTextTheme.semiBoldThree,
                        color: Color(0xFF007BFF),
                        onPressed: () {
                          if (globalKey.currentState?.validate() ?? false) {
                            value.updateUserDetails(
                              email: emailController.text,
                            );
                          }
                        },
                        radius: 8.r,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget verifyPANWidget() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20.w,
              children: [
                IconButton(
                  onPressed: () {
                    pageController.previousPage(
                      duration: Durations.short3,
                      curve: Curves.easeIn,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text("Verify PAN Number", style: AppTextTheme.semiBold),
              ],
            ),
            SizedBox(height: 32.h),
            Center(
              child: Image.asset(
                AppAssetPath.panImage,
                height: 170.h,
                width: 170.w,
              ),
            ),
            SizedBox(height: 32.h),
            Text("Enter your PAN Number*", style: AppTextTheme.semiBoldThree),
            SizedBox(height: 12.h),
            CustomTextFormField(
              controller: panController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              hintText: "e.g: ABCDE123F",
              textInputType: TextInputType.emailAddress,
              validator: (value) => value == null || value.isEmpty
                  ? "Please enter your PAN Number"
                  : null,
              onChanged: null,
            ),
            SizedBox(height: 90.h),
            Consumer<UserViewModel>(
              builder: (context, value, child) {
                return value.updateUserState == AppState.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : CustomOutlinedButton(
                        buttonName: "Verify",
                        textStyle: AppTextTheme.semiBoldThree,
                        color: Color(0xFF007BFF),
                        onPressed: () {
                          if (globalKey.currentState?.validate() ?? false) {
                            value.updateUserDetails(
                              panNumber: panController.text,
                              isLastStep: true,
                            );
                          }
                        },
                        radius: 8.r,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
