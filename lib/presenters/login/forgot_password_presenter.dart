import '../../strings.dart';
import '../../contracts/login/forgot_password_contract.dart';
import '../../services/firebase/firebase_forgot_password_service.dart';

class ForgotPasswordPresenter extends ForgotPasswordContractPresenter {
  ForgotPasswordContractService repository = FirebaseForgotPasswordService();

  ForgotPasswordPresenter(ForgotPasswordContractView view) : super(view);

  @override
  sendEmail(String email) {
    view.showProgress();
    repository.sendEmail(email).then((result) {
      view.hideProgress();
      view.onSuccess("Email enviado com sucesso!");
    }).catchError((error) {
      view.hideProgress();
      switch(error.code) {
        case "ERROR_USER_NOT_FOUND":
          view.onFailure(USUARIO_NAO_ENCONTRADO);
          break;
        default:
          view.onFailure(error.toString());
      }
    });
  }

}