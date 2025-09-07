import 'package:mobileapp/core/enums/loan_status.dart';
import 'package:mobileapp/core/extensions/string_extension.dart';

class LoanModel {
  LoanModel({
    required this.id,
    required this.requestedBy,
    required this.purposeOfLoan,
    required this.principalAmount,
    required this.tenure,
    required this.status,
    required this.v,
  });

  final String? id;
  final String? requestedBy;
  final String? purposeOfLoan;
  final int? principalAmount;
  final int? tenure;
  final LoanStatus status;
  final int? v;

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json["_id"],
      requestedBy: json["requestedBy"],
      purposeOfLoan: json["purposeOfLoan"],
      principalAmount: json["principalAmount"],
      tenure: json["tenure"],
      status: ((json["status"] ?? "") as String).loanStatus,
      v: json["__v"],
    );
  }
}
