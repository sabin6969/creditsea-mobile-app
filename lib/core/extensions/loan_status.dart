import 'package:mobileapp/core/enums/loan_status.dart';

extension LoanStausExtension on LoanStatus {
  String get readAbleForm {
    switch (this) {
      case LoanStatus.applicationSubmitted:
        return "Application Submitted";
      case LoanStatus.applicationUnderReview:
        return "Application under Review";
      case LoanStatus.eKYC:
        return "E-KYC";
      case LoanStatus.eNach:
        return "E-Nach";
      case LoanStatus.eSign:
        return "E-Sign";
      case LoanStatus.disbursement:
        return "Disbursement";
    }
  }

  int get number {
    switch (this) {
      case LoanStatus.applicationSubmitted:
        return 0;
      case LoanStatus.applicationUnderReview:
        return 1;
      case LoanStatus.eKYC:
        return 2;
      case LoanStatus.eNach:
        return 3;
      case LoanStatus.eSign:
        return 4;
      case LoanStatus.disbursement:
        return 5;
    }
  }
}
