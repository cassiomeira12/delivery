import '../../contracts/base_result_contract.dart';
import '../../models/base_user.dart';
import '../base_progress_contract.dart';

abstract class LoginContractView implements BaseProgressContract, BaseResultContract<BaseUser> {

}

abstract class LoginContractPresenter {
  dispose();
  signIn(String email, String password);
  signInWithGoogle();
  signAnonymous();
  onFailure(String error);
  onSuccess(BaseUser user);
}

abstract class LoginContractService {
  dispose();
  signIn(String email, String password);
  signAnonymous();
  signInWithGoogle();
}