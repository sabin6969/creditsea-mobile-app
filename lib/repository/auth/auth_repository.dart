import 'dart:convert';

import 'package:mobileapp/core/constants/app_end_points.dart';
import 'package:mobileapp/network/network_api.dart';

class AuthRepository {
  NetworkApi networkApi = NetworkApi.instance;

  Future<void> sendOtp({required String mobileNumber}) async {
    try {
      await networkApi.postRequest(
        data: {"mobileNumber": mobileNumber},
        endPoint: AppEndPoints.requestOtpEndPoint,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> verifyOtp({
    required String enteredOtp,
    required String mobileNumber,
  }) async {
    try {
      await networkApi.postRequest(
        data: {"mobileNumber": mobileNumber, "userEnteredOtp": enteredOtp},
        endPoint: AppEndPoints.verifyOtpEndPoint,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> createAccount({
    required String mobileNumber,
    required String password,
    required bool isPhoneNumberVerified,
    required String? fcmToken,
    required bool isMobileNumberVerified,
  }) async {
    try {
      await networkApi.postRequest(
        data: {
          "mobileNumber": mobileNumber,
          "password": password,
          "fcmToken": fcmToken,
          "isMobileNumberVerified": isMobileNumberVerified,
        },
        endPoint: AppEndPoints.createAccountEndPoint,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String?> login({
    required String mobileNumber,
    required String password,
    required String? fcmToken,
  }) async {
    try {
      String responseBody = await networkApi.postRequest(
        data: {
          "mobileNumber": mobileNumber,
          "password": password,
          "fcmToken": fcmToken,
        },
        endPoint: AppEndPoints.loginEndPoint,
      );

      return jsonDecode(responseBody)["data"]["token"];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future updateUserDetails({
    String? firstName,
    String? lastName,
    String? gender,
    int? dateOfBirth,
    String? maritalStatus,
    String? email,
    String? panNumber,
  }) async {
    try {
      await networkApi.postRequest(
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "gender": gender,
          "dateOfBirth": dateOfBirth,
          "maritalStatus": maritalStatus,
          "email": email,
          "panNumber": panNumber,
        },
        endPoint: AppEndPoints.updateUserDetailsEndPoint,
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}
