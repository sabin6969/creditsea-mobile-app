import 'package:flutter/material.dart';
import 'package:mobileapp/core/constants/app_path.dart';
import 'package:mobileapp/view/approval/approval_view.dart';
import 'package:mobileapp/view/calculator/calculator_view.dart';
import 'package:mobileapp/view/home/home_page.dart';
import 'package:mobileapp/view/offer/loan_offer_view.dart';

class RouteGenerator {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    Map<String, dynamic>? data = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case AppPath.homePage:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case AppPath.calculatorPage:
        return MaterialPageRoute(builder: (context) => const CalculatorView());
      case AppPath.approvalPage:
        return MaterialPageRoute(
          builder: (context) => ApprovalView(id: data?["id"]),
        );
      case AppPath.loanOfferPage:
        return MaterialPageRoute(
          builder: (context) => LoanOfferView(
            tenure: data?["tenure"],
            principalAmount: data?["principalAmount"],
            purposeOfLoan: data?["purposeOfLoan"],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text("I am lost"))),
        );
    }
  }
}
