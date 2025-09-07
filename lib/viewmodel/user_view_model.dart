import 'package:flutter/material.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/exceptions/app_exceptions.dart';
import 'package:mobileapp/core/storage/secure_storage_service.dart';
import 'package:mobileapp/core/utils/retrive_fcm_token.dart';
import 'package:mobileapp/repository/auth/auth_repository.dart';

class UserViewModel extends ChangeNotifier {
  AuthRepository authRepository;

  UserViewModel({required this.authRepository});

  AppState _appState = AppState.idle;

  AppState get appState => _appState;

  AppState _loginState = AppState.idle;

  AppState get loginState => _loginState;

  AppState _updateUserState = AppState.idle;

  AppState get updateUserState => _updateUserState;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLastStep = false;

  bool get isLastStep => _isLastStep;

  set _changeAppState(AppState newState) {
    if (newState != _appState) {
      _appState = newState;
      notifyListeners();
    }
  }

  set _changeLoginState(AppState newState) {
    if (newState != _loginState) {
      _loginState = newState;
      notifyListeners();
    }
  }

  set _changeUpdateUserDetailsState(AppState newState) {
    if (newState != _updateUserState) {
      _updateUserState = newState;
      notifyListeners();
    }
  }

  void resetState() {
    _appState = AppState.idle;
  }

  void resetLoginState() {
    _loginState = AppState.idle;
  }

  void createAccount({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      _changeAppState = AppState.loading;
      String? fcmToken = await retriveFcmToken();
      await authRepository.createAccount(
        mobileNumber: mobileNumber,
        password: password,
        isPhoneNumberVerified: true,
        fcmToken: fcmToken,
        isMobileNumberVerified: true,
      );
      _changeAppState = AppState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _changeAppState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong while creating account";
      _changeAppState = AppState.error;
    }
  }

  void login({required String mobileNumber, required String password}) async {
    try {
      _changeLoginState = AppState.loading;
      String? fcmToken = await retriveFcmToken();
      String? token = await authRepository.login(
        mobileNumber: mobileNumber,
        password: password,
        fcmToken: fcmToken,
      );
      await SecureStorageService.writeValue(
        key: SecureStorageService.jwtKey,
        value: token,
      );
      _changeLoginState = AppState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _changeLoginState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong while login";
      _changeLoginState = AppState.error;
    }
  }

  void updateUserDetails({
    String? firstName,
    String? lastName,
    String? gender,
    int? dateOfBirth,
    String? maritalStatus,
    String? email,
    String? panNumber,
    bool? isLastStep,
  }) async {
    try {
      _changeUpdateUserDetailsState = AppState.loading;
      await authRepository.updateUserDetails(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        maritalStatus: maritalStatus,
        email: email,
        panNumber: panNumber,
      );
      _isLastStep = isLastStep ?? false;
      _changeUpdateUserDetailsState = AppState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _changeUpdateUserDetailsState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong";
      _changeUpdateUserDetailsState = AppState.error;
    }
  }
}
