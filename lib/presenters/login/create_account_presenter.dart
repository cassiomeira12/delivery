import '../../contracts/login/create_account_contract.dart';
import '../../models/base_user.dart';
import '../../services/firebase/firebase_create_account_service.dart';

class CreateAccountPresenter extends CreateAccountContractPresenter {
  CreateAccountContractView _view;
  CreateAccountContractService service;

  CreateAccountPresenter(this._view) {
    FirebaseCreateAccountService(this);
  }

  @override
  dispose() {
    service.dispose();
    _view = null;
  }

  @override
  createAccount(BaseUser user) {
    if (_view != null) _view.showProgress();
    if (service != null) service.createAccount(user);
  }

  @override
  onFailure(String error) {
    if (_view != null) _view.hideProgress();
    if (service != null) _view.onFailure(error.toString());
  }

  @override
  onSuccess(BaseUser user) {
    if (_view != null) _view.hideProgress();
    if (service != null) _view.onSuccess(user);
  }

}