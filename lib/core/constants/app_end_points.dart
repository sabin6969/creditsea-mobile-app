class AppEndPoints {
  static final String _baseUrl = "http://192.168.31.204:4000/api";

  // user
  static String requestOtpEndPoint = "$_baseUrl/user/requestOtp";
  static String verifyOtpEndPoint = "$_baseUrl/user/verifyOtp";
  static String loginEndPoint = "$_baseUrl/user/login";
  static String createAccountEndPoint = "$_baseUrl/user/createAccount";
  static String updateUserDetailsEndPoint = "$_baseUrl/user/update";
  static String applyForLoanEndPoint = "$_baseUrl/loan/apply";
  static String loanDetailsById({required String id}) => "$_baseUrl/loan/$id";
}
