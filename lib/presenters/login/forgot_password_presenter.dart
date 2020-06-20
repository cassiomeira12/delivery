import 'package:delivery/services/parse/parse_forgot_password_service.dart';

import '../../strings.dart';
import '../../contracts/login/forgot_password_contract.dart';
import '../../services/firebase/firebase_forgot_password_service.dart';

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
        if (_view != null) _view.hideProgress();
        if (_view != null) _view.onSuccess("Email enviado com sucesso!");
      }).catchError((error) {
        if (_view != null) _view.hideProgress();
        try {
          switch(error.code) {
            case "ERROR_USER_NOT_FOUND":
              if (_view != null) _view.onFailure(USUARIO_NAO_ENCONTRADO);
              break;
            default:
              if (_view != null) _view.onFailure(error.toString());
          }
        } catch (exception) {
          if (_view != null) _view.onFailure(ERROR_ENVIAR_EMAIL);
        }
      });
    }
  }

}