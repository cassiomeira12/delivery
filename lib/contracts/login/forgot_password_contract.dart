import '../../contracts/base_result_contract.dart';
import '../base_progress_contract.dart';

abstract class ForgotPasswordContractView implements BaseProgressContract, BaseResultContract<String> {

}

abstract class ForgotPasswordContractPresenter {
  dispose();
  sendEmail(String email);
}

abstract class ForgotPasswordContractService {
  Future<void> sendEmail(String email);
}