import 'package:mobileapp/core/constants/app_asset_path.dart';

class OnboardingModel {
  static String onboardingCreditSeaLogo = AppAssetPath.creditSeaOnboardingLogo;

  final String onboardingImagePath;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.onboardingImagePath,
    required this.title,
    required this.subtitle,
  });

  static List<OnboardingModel> onboardingData() {
    return [
      OnboardingModel(
        onboardingImagePath: AppAssetPath.creditSeaOnboardingImageOne,
        title: "Flexible Loan Options",
        subtitle: "Loan types to cater to different financial needs",
      ),
      OnboardingModel(
        onboardingImagePath: AppAssetPath.creditSeaOnboardingImageTwo,
        title: "Instant Loan Approval",
        subtitle: "Users will receive approval within minutes",
      ),

      OnboardingModel(
        onboardingImagePath: AppAssetPath.creditSeaOnboardingImageThree,
        title: "24x7 Customer Care",
        subtitle: "Dedicated customer support team",
      ),
    ];
  }
}
