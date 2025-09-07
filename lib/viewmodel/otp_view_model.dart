import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/exceptions/app_exceptions.dart';
import 'package:mobileapp/repository/auth/auth_repository.dart';

class OtpViewModel extends ChangeNotifier {
  AuthRepository authRepository;

  OtpViewModel({required this.authRepository});

  AppState _appState = AppState.idle;

  AppState get appState => _appState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _selectedCountryCode = "+91";

  String get selectedCountryCode => _selectedCountryCode;

  set _changeAppState(AppState newState) {
    if (newState != _appState) {
      _appState = newState;
      notifyListeners();
    }
  }

  void setCountryCode(String code) {
    _selectedCountryCode = code;
  }

  void resetState() {
    _appState = AppState.idle;
  }

  String? _phoneNumber;

  String? get phoneNumber => "$_selectedCountryCode$_phoneNumber";

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  int _counter = 30;

  int get counter => _counter;

  void startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        timer.cancel();
        return;
      }
      _counter--;
      notifyListeners();
    });
  }

  void resetCounter() {
    _counter = 30;
  }

  void sendOtp({required String mobileNumber}) async {
    try {
      _changeAppState = AppState.loading;
      await authRepository.sendOtp(mobileNumber: mobileNumber);
      _changeAppState = AppState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _changeAppState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong while requesting for otp";
      _changeAppState = AppState.error;
    }
  }
}
