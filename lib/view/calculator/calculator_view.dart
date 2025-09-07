import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/constants/app_asset_path.dart';
import 'package:mobileapp/core/constants/app_path.dart';
import 'package:mobileapp/core/theme/app_text_theme.dart';
import 'package:mobileapp/core/widgets/custom_outlined_button.dart';
import 'package:mobileapp/core/widgets/toast_message.dart';
import 'package:mobileapp/services/notification/local_notification_service.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  List<String> purposeOfLoan = [
    "Personal Loan",
    "Educational Loan",
    "Vehicle Loan",
    "Home Loan",
  ];

  late GlobalKey<FormState> globalKey;

  late ValueNotifier<String?> selectedPurposeOfLoan;
  late ValueNotifier<double> principalAmount;
  late ValueNotifier<int> tenure;

  @override
  void initState() {
    selectedPurposeOfLoan = ValueNotifier(null);
    principalAmount = ValueNotifier(0.3);
    tenure = ValueNotifier(40);
    globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    selectedPurposeOfLoan.dispose();
    principalAmount.dispose();
    tenure.dispose();
    super.dispose();
  }

  // Calculate principal amount based on slider value (e.g., ₹0 to ₹100,000)
  int getCalculatedPrincipal(double sliderValue) {
    return (sliderValue * 100000).round(); // Scale to ₹100,000 max
  }

  // Calculate total payable (1% interest per day + 10% processing fee)
  int getTotalPayable(int principal, int days) {
    double interest = principal * 0.01 * days; // 1% per day
    double processingFee = principal * 0.10; // 10% processing fee
    return (principal + interest + processingFee).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppAssetPath.creditSeaLogo),
        centerTitle: true,
        toolbarHeight: 106.h,
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            constraints: BoxConstraints(minHeight: double.infinity),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              border: Border.all(color: Colors.black, width: 0.4.w),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 24.w,
                vertical: 24.h,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: null,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              weight: 2,
                            ),
                          ),
                          Text("Apply for loan", style: AppTextTheme.semiBold),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "We’ve calculated your loan eligibility. Select your preferred loan amount and tenure.",
                        style: AppTextTheme.semiBoldThree.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Text("Interest Per Day 1%"),
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Text("Processing Fee 10%"),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      const Divider(),
                      SizedBox(height: 24.h),
                      Text(
                        "Purpose of Loan*",
                        style: AppTextTheme.semiBoldThree,
                      ),
                      SizedBox(height: 12.h),
                      ValueListenableBuilder(
                        valueListenable: selectedPurposeOfLoan,
                        builder: (context, value, child) {
                          return DropdownButtonFormField<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            hint: Text("Select purpose of loan"),
                            validator: (value) => value == null || value.isEmpty
                                ? "Please select the purpose of loan"
                                : null,
                            value: value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: purposeOfLoan
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              selectedPurposeOfLoan.value = value;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 36.h),
                      Row(
                        children: [
                          Text(
                            "Principal Amount",
                            style: AppTextTheme.semiBoldThree,
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      ValueListenableBuilder(
                        valueListenable: principalAmount,
                        builder: (context, value, child) {
                          int calculatedPrincipal = getCalculatedPrincipal(
                            value,
                          );
                          return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xFF0056A4),
                              inactiveTrackColor: Colors.grey[300],
                              trackHeight: 8.0,
                              thumbColor: Color(0xFF0056A4),
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 10.0,
                              ),
                              overlayColor: Color(
                                0xFF0056A4,
                              ).withValues(alpha: 0.2),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 20.0,
                              ),
                            ),
                            child: Slider(
                              value: value,
                              min: 0.0,
                              max: 1.0,
                              divisions: 100,
                              label: "₹${calculatedPrincipal.round()}",
                              onChanged: (newValue) {
                                principalAmount.value = newValue;
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 40.h),
                      Row(
                        children: [
                          Text("Tenure", style: AppTextTheme.semiBoldThree),
                        ],
                      ),
                      SizedBox(height: 27.h),
                      ValueListenableBuilder(
                        valueListenable: tenure,
                        builder: (context, value, child) {
                          return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xFF0056A4),
                              inactiveTrackColor: Colors.grey[300],
                              trackHeight: 8.0,
                              thumbColor: Color(0xFF0056A4),
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 10.0,
                              ),
                              overlayColor: Color(
                                0xFF0056A4,
                              ).withValues(alpha: 0.2),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 20.0,
                              ),
                            ),
                            child: Slider(
                              value: value.toDouble(),
                              min: 20.0,
                              max: 45.0,
                              divisions: 25,
                              label: "$value Days",
                              onChanged: (newValue) {
                                tenure.value = newValue.round();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 0.8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "20 Days",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "45 Days",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      ValueListenableBuilder(
                        valueListenable: principalAmount,
                        builder: (context, principalValue, child) {
                          return ValueListenableBuilder(
                            valueListenable: tenure,
                            builder: (context, tenureValue, child) {
                              int calculatedPrincipal = getCalculatedPrincipal(
                                principalValue,
                              );
                              int totalPayable = getTotalPayable(
                                calculatedPrincipal,
                                tenureValue,
                              );
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 20.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF0056A4)),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Principle Amount"),
                                        Text(
                                          "₹${calculatedPrincipal.round()}",
                                          style: AppTextTheme.semiBoldTwo
                                              .copyWith(
                                                color: Color(0xFF0056A4),
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Interest"),
                                        Text(
                                          "1%",
                                          style: AppTextTheme.semiBoldTwo
                                              .copyWith(
                                                color: Color(0xFF0056A4),
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Payable"),
                                        Text(
                                          "₹$totalPayable",
                                          style: AppTextTheme.semiBoldTwo
                                              .copyWith(
                                                color: Color(0xFF0056A4),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Thank you for choosing CreditSea. Please accept to proceed with the loan details.",
                        textAlign: TextAlign.center,
                        style: AppTextTheme.semiBoldThree.copyWith(
                          color: Color(0xFF0056A4),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      CustomOutlinedButton(
                        buttonName: "Apply",
                        color: Color(0xFF0056A4),
                        textStyle: AppTextTheme.semiBoldThree,
                        onPressed: () {
                          if (globalKey.currentState?.validate() ?? false) {
                            Navigator.pushNamed(
                              context,
                              AppPath.loanOfferPage,
                              arguments: {
                                "tenure": tenure.value,
                                "principalAmount": principalAmount.value,
                                "purposeOfLoan": selectedPurposeOfLoan.value,
                              },
                            );
                          } else {
                            showToastMessage(
                              message: "Please fill required fields",
                            );
                          }
                        },
                        radius: 8.r,
                      ),
                      SizedBox(height: 14.h),
                      CustomOutlinedButton(
                        buttonName: "Cancel",
                        color: Colors.transparent,
                        onPressed: () {
                          LocalNotificationService.sendNotification(
                            title: "Title is here",
                            body: "Body is here",
                          );
                        },
                        radius: 8.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        enableDrag: false,
      ),
    );
  }
}
