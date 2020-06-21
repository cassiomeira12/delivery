import '../../services/parse/parse_forgot_password_service.dart';
import '../../contracts/login/forgot_password_contract.dart';
import '../../services/firebase/firebase_forgot_password_service.dart';
import '../../strings.dart';

class ForgotPasswordPresenter extends ForgotPasswordContractPresenter {
  ForgotPasswordContractView _view;
  //ForgotPasswordContractService service = FirebaseForgotPasswordService();
  ForgotPasswordContractService service = ParseForgotPasswordService();

  ForgotPasswordPresenter(this._view);

  @override
  dispose() {
    service = null;
    _view = null;
  }
  
  @override
  sendEmail(String email) {
    if (_view != null) _view.showProgress();
    if (service != null) {
      service.sendEmail(email).then((result) {
        if (_view != null) _view.onSuccess(SUCCESS_EMAIL_SEND);
      }).catchError((error) {
        _view.onFailure(error.message);
      });
    }
  }

}