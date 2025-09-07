import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/exceptions/app_exceptions.dart';
import 'package:mobileapp/repository/auth/auth_repository.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  AuthRepository authRepository;

  VerifyOtpViewModel({required this.authRepository});

  AppState _appState = AppState.idle;

  AppState get appState => _appState;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set _changeAppState(AppState newState) {
    if (newState != _appState) {
      _appState = newState;
      notifyListeners();
    }
  }

  void resetState() {
    _appState = AppState.idle;
  }

  void verifyOtp({
    required String enteredOtp,
    required String mobileNumber,
  }) async {
    try {
      _changeAppState = AppState.loading;
      await authRepository.verifyOtp(
        enteredOtp: enteredOtp,
        mobileNumber: mobileNumber,
      );
      _changeAppState = AppState.success;
    } on AppException catch (e) {
      log("The error is ${e.message}");
      _errorMessage = e.message;
      _changeAppState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong while verifying otp";
      _changeAppState = AppState.error;
    }
  }
}
