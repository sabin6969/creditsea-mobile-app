import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/model/onboarding/onboarding_model.dart';
import 'package:mobileapp/view/auth/widgets/create_password_widget.dart';
import 'package:mobileapp/view/auth/widgets/enter_otp_widget.dart';
import 'package:mobileapp/view/auth/widgets/login_widget.dart';
import 'package:mobileapp/view/auth/widgets/register_number_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  late PageController pageController;
  late PageController bottomPageController;
  late TextEditingController mobileNumberController;
  String? enteredMobileNumber;

  @override
  void initState() {
    pageController = PageController();
    mobileNumberController = TextEditingController();
    mobileNumberController.addListener(() {
      enteredMobileNumber = mobileNumberController.text;
    });
    bottomPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    bottomPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF0056A4),
      body: Column(
        children: [
          Container(
            height: size.height * 0.57,
            width: double.infinity,
            color: Color(0xFF0056A4),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: OnboardingModel.onboardingData().length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 56.h),
                          Image.asset(
                            OnboardingModel.onboardingCreditSeaLogo,
                            width: 243.w,
                            height: 70.h,
                          ),
                          SizedBox(height: 22.h),
                          Image.asset(
                            OnboardingModel.onboardingData()[index]
                                .onboardingImagePath,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            OnboardingModel.onboardingData()[index].title,
                            style: AppTextTheme.semiBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            OnboardingModel.onboardingData()[index].subtitle,
                            style: AppTextTheme.mediumTwo.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SmoothPageIndicator(
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.white38,
                    activeDotColor: Colors.white,
                  ),

                  onDotClicked: (index) {
                    pageController.animateToPage(
                      index,
                      curve: Curves.easeIn,
                      duration: Durations.short3,
                    );
                  },
                  controller: pageController,
                  count: OnboardingModel.onboardingData().length,
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
          Container(
            height: size.height * 0.43,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              border: Border(top: BorderSide(width: 5, color: Colors.purple)),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: bottomPageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        RegisterNumberWidget(
                          pageController: bottomPageController,
                        ),
                        EnterOtpWidget(pageController: bottomPageController),
                        CreatePasswordWidget(
                          pageController: bottomPageController,
                        ),
                        LoginWidget(pageController: bottomPageController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
