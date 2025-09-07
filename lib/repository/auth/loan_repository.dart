import 'dart:convert';

import 'package:mobileapp/core/constants/app_end_points.dart';
import 'package:mobileapp/model/loan/loan_model.dart';
import 'package:mobileapp/network/network_api.dart';

class LoanRepository {
  NetworkApi networkApi = NetworkApi.instance;

  Future<String> submitLoanApplication({
    required String purposeOfLoan,
    required int tenure,
    required int principalAmount,
  }) async {
    try {
      String responseBody = await networkApi.postRequest(
        data: {
          "purposeOfLoan": purposeOfLoan,
          "tenure": tenure,
          "principalAmount": principalAmount,
        },

        endPoint: AppEndPoints.applyForLoanEndPoint,
      );
      // log(data);
      return jsonDecode(responseBody)["data"]["_id"];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<LoanModel> getLoanDetailsById({required String id}) async {
    try {
      String responseBody = await networkApi.getRequest(
        endPoint: AppEndPoints.loanDetailsById(id: id),
      );
      return LoanModel.fromJson(jsonDecode(responseBody)["data"]);
    } catch (e) {
      return Future.error(e);
    }
  }
}
