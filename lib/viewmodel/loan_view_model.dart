import 'package:flutter/material.dart';
import 'package:mobileapp/core/constants/app_state.dart';
import 'package:mobileapp/core/exceptions/app_exceptions.dart';
import 'package:mobileapp/model/loan/loan_model.dart';
import 'package:mobileapp/repository/auth/loan_repository.dart';

class LoanViewModel extends ChangeNotifier {
  LoanRepository loanRepository;

  LoanViewModel({required this.loanRepository});

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  AppState _appState = AppState.idle;

  AppState get appState => _appState;

  String? _id;

  String? get loanId => _id;

  AppState _loanDetailsByIdState = AppState.idle;

  AppState get loanDetailsByIdState => _loanDetailsByIdState;

  late LoanModel _loanModel;

  LoanModel get loanModel => _loanModel;

  set _changeAppState(AppState newState) {
    if (newState != _appState) {
      _appState = newState;
      notifyListeners();
    }
  }

  set _changeLoanDetailByIdState(AppState newState) {
    if (newState != _loanDetailsByIdState) {
      _loanDetailsByIdState = newState;
      notifyListeners();
    }
  }

  void resetAppState() {
    _appState = AppState.idle;
  }

  void applyForLoan({
    required String purposeOfLoan,
    required int tenure,
    required int principalAmount,
  }) async {
    try {
      _changeAppState = AppState.loading;
      _id = await loanRepository.submitLoanApplication(
        purposeOfLoan: purposeOfLoan,
        tenure: tenure,
        principalAmount: principalAmount,
      );
      _changeAppState = AppState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _changeAppState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong while applying for loan";
      _changeAppState = AppState.error;
    }
  }

  void getLoanDetailsById({required String id}) async {
    try {
      _changeLoanDetailByIdState = AppState.idle;
      _loanModel = await loanRepository.getLoanDetailsById(id: id);
      _changeLoanDetailByIdState = AppState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _changeLoanDetailByIdState = AppState.error;
    } catch (e) {
      _errorMessage = "Something went wrong while getting loan details by id";
      _changeLoanDetailByIdState = AppState.error;
    }
  }
}
