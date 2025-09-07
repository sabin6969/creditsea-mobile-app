import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_asset_path.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/enums/loan_status.dart';
import 'package:mobileapp/core/extensions/loan_status.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/step_widget.dart';
import 'package:mobileapp/viewmodel/loan_view_model.dart';
import 'package:provider/provider.dart';

class ApprovalView extends StatefulWidget {
  final String id;
  const ApprovalView({super.key, required this.id});

  @override
  State<ApprovalView> createState() => _ApprovalViewState();
}

class _ApprovalViewState extends State<ApprovalView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      log("The id is ${widget.id}");
      context.read<LoanViewModel>().getLoanDetailsById(id: widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.h,
        automaticallyImplyLeading: false,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 55.w,
            children: [
              stepWidget(index: 1, title: "Register", isSelected: false),
              stepWidget(index: 2, title: "Offer", isSelected: false),
              stepWidget(index: 3, title: "Approval", isSelected: true),
            ],
          ),
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: double.infinity,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              border: Border.all(color: Colors.black, width: 0.4.w),
            ),
            child: Consumer<LoanViewModel>(
              builder: (context, value, child) {
                switch (value.loanDetailsByIdState) {
                  case AppState.error:
                    return Center(
                      child: Text(value.errorMessage ?? "Something went wrong"),
                    );
                  case AppState.success:
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Application Status",
                                  style: AppTextTheme.semiBold,
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<LoanViewModel>()
                                        .getLoanDetailsById(id: widget.id);
                                  },
                                  icon: const Icon(Icons.refresh),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "Loan Application no: ${value.loanModel.id ?? "N/A"}",
                              style: AppTextTheme.medium,
                            ),
                            SizedBox(height: 24.h),
                            ...LoanStatus.values.map(
                              (e) => statusWidget(
                                currentStep: value.loanModel.status.index,
                                lastStep: LoanStatus.disbursement.index,
                                status: e,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Center(child: Image.asset(AppAssetPath.groupImage)),
                            SizedBox(height: 6.h),
                            Center(
                              child: Text(
                                value.loanModel.status.readAbleForm,
                                style: AppTextTheme.semiBoldTwo,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "We’re carefully reviewing your application to ensure everything is in order. Thank you for your patience.",
                              textAlign: TextAlign.center,
                              style: AppTextTheme.mediumTwo,
                            ),
                            SizedBox(height: 81.h),
                            CustomOutlinedButton(
                              buttonName: "Continue",
                              color: Color(0xFF007BFF),
                              textStyle: AppTextTheme.semiBoldThree,

                              onPressed: () {},
                              radius: 8.r,
                            ),
                          ],
                        ),
                      ),
                    );
                  case AppState.loading:
                    return Center(child: CircularProgressIndicator.adaptive());
                  case AppState.idle:
                    return const SizedBox.shrink();
                }
              },
            ),
          );
        },
        enableDrag: false,
      ),
    );
  }

  Widget statusWidget({
    required LoanStatus status,
    required int currentStep,
    required int lastStep,
  }) {
    return Column(
      children: [
        Container(
          height: 48.h,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: status.index < currentStep
                  ? Colors.green
                  : status.index == currentStep
                  ? Colors.blue
                  : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.checklist,
                size: 25,
                color: status.index < currentStep
                    ? Colors.green
                    : status.index == currentStep
                    ? Colors.blue
                    : Colors.grey,
              ),

              Center(
                child: Text(status.readAbleForm, textAlign: TextAlign.center),
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
        status == LoanStatus.disbursement
            ? const SizedBox.shrink()
            : SizedBox(
                height: 26.h,

                child: VerticalDivider(
                  width: 3,
                  color: status.index < currentStep
                      ? Colors.green
                      : status.index == currentStep
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
      ],
    );
  }
}
