import '../../contracts/login/forgot_password_contract.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class ParseForgotPasswordService implements ForgotPasswordContractService {

  @override
  Future<void> sendEmail(String email) async {
    return await ParseUser(null, null, email).requestPasswordReset().then((value) {
      return value.success ? null : throw Exception();
    });
  }

}