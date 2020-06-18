import '../../contracts/login/login_contract.dart';
import '../../models/base_user.dart';
import '../../services/firebase/firebase_login_service.dart';

class LoginPresenter extends LoginContractPresenter {
  LoginContractView _view;
  LoginContractService service;

  LoginPresenter(this._view) {
    this.service = FirebaseLoginService(this);
  }

  @override
  dispose() {
    service.dispose();
    service = null;
    _view = null;
  }

  @override
  signIn(String email, String password) {
    if (_view != null) _view.showProgress();
    if (service != null) service.signIn(email, password);
  }

  @override
  signInWithGoogle() {
    if (_view != null) _view.showProgress();
    if (service != null) service.signInWithGoogle();
  }

  @override
  onFailure(String error) {
    if (_view != null) _view.hideProgress();
    if (_view != null) _view.onFailure(error);
  }

  @override
  onSuccess(BaseUser user) {
    if (_view != null) _view.hideProgress();
    if (_view != null) _view.onSuccess(user);
  }

}