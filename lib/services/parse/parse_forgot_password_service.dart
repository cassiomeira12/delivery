import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../../contracts/login/forgot_password_contract.dart';
import '../../strings.dart';

class ParseForgotPasswordService implements ForgotPasswordContractService {

  @override
  Future<void> sendEmail(String email) async {
    return await ParseUser(null, null, email).requestPasswordReset().then((value) {
      if (value.success) {
        return null;
      } else {
        switch (value.error.code) {
          case -1:
            throw Exception(ERROR_NETWORK);
            break;
          default:
            throw Exception(value.error);
        }
      }
    });
  }

}