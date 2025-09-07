import 'package:mobileapp/core/enums/loan_status.dart';

extension StringExtension on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(trim());
  }
}

extension LoanExtension on String {
  LoanStatus get loanStatus {
    switch (this) {
      case "Application Submitted":
        return LoanStatus.applicationSubmitted;
      case "Application under Review":
        return LoanStatus.applicationUnderReview;
      case "E-KYC":
        return LoanStatus.eKYC;
      case "E-Nach":
        return LoanStatus.eNach;
      case "E-Sign":
        return LoanStatus.eSign;
      case "Disbursement":
        return LoanStatus.disbursement;
      default:
        return LoanStatus.applicationSubmitted;
    }
  }
}
