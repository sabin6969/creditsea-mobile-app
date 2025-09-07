import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_asset_path.dart';
import 'package:mobileapp/core/constants/app_path.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/step_widget.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/viewmodel/loan_view_model.dart';
import 'package:provider/provider.dart';

class LoanOfferView extends StatefulWidget {
  final String purposeOfLoan;
  final int tenure;
  final double principalAmount;
  const LoanOfferView({
    super.key,
    required this.principalAmount,
    required this.purposeOfLoan,
    required this.tenure,
  });

  @override
  State<LoanOfferView> createState() => _LoanOfferViewState();
}

class _LoanOfferViewState extends State<LoanOfferView> {
  void viewModelListener() {
    if (!mounted) return;
    AppState appState = context.read<LoanViewModel>().appState;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appState == AppState.success) {
        Navigator.pushReplacementNamed(
          context,
          AppPath.approvalPage,
          arguments: {"id": context.read<LoanViewModel>().loanId ?? ""},
        );
        context.read<LoanViewModel>().resetAppState();
      } else if (appState == AppState.error) {
        showToastMessage(
          message:
              context.read<LoanViewModel>().errorMessage ??
              "Something went wrong",
        );
      }
    });
  }

  @override
  void initState() {
    context.read<LoanViewModel>().addListener(viewModelListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 52.w,
            children: [
              stepWidget(index: 1, title: "Register", isSelected: false),
              stepWidget(index: 2, title: "Offer", isSelected: true),
              stepWidget(index: 3, title: "Approval", isSelected: false),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Our Offerings", style: AppTextTheme.semiBold),
            Center(
              child: Image.asset(
                AppAssetPath.coinImage,
                height: 200.h,
                width: 200.w,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Congratulations! ",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "We can offer you Rs. ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: "10,000",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: " Amount Within 30 minutes for ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: "90 days",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: ", with a payable amount of Rs. ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: "10,600",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: ". Just with few more steps.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: "\nProceed further to ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60.h),
            Consumer<LoanViewModel>(
              builder: (context, value, child) {
                return value.appState == AppState.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : CustomOutlinedButton(
                        buttonName: "Accept Offer",
                        color: Color(0xFF007BFF),
                        textStyle: AppTextTheme.semiBoldThree,
                        onPressed: () {
                          value.applyForLoan(
                            purposeOfLoan: widget.purposeOfLoan,
                            tenure: widget.tenure,
                            principalAmount: (widget.principalAmount * 100000)
                                .toInt(),
                          );
                        },
                        radius: 8.r,
                      );
              },
            ),
            SizedBox(height: 15.h),
            CustomOutlinedButton(
              buttonName: "Extend Offer",
              color: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              radius: 8.r,
            ),
          ],
        ),
      ),
    );
  }
}
