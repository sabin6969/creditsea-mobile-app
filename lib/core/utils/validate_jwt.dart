import 'package:jwt_decoder/jwt_decoder.dart';

bool validateJwt({required String token}) {
  try {
    JwtDecoder.decode(token);
    return true;
  } catch (e) {
    return false;
  }
}
