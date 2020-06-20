import '../../models/base_user.dart';
import '../base_progress_contract.dart';
import '../base_result_contract.dart';

abstract class CreateAccountContractView implements BaseProgressContract, BaseResultContract<BaseUser> {

}

abstract class CreateAccountContractPresenter {
  dispose();

  Future<BaseUser> createAccount(BaseUser user);

  onFailure(String error);
  onSuccess(BaseUser user);
}

abstract class CreateAccountContractService {
//  CreateAccountContractPresenter presenter;
//  CreateAccountContractService(this.presenter);
//
//  dispose() {
//    this.presenter = null;
//  }
  dispose();
  Future<BaseUser> createAccount(BaseUser user);
}