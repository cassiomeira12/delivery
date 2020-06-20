import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../../strings.dart';
import '../../utils/preferences_util.dart';
import '../../contracts/login/login_contract.dart';
import '../../models/base_user.dart';
import '../../utils/log_util.dart';

class ParseLoginService implements LoginContractService {
  LoginContractPresenter presenter;

  ParseLoginService(this.presenter);

  @override
  dispose() {
    presenter = null;
  }

  @override
  signIn(String email, String password) async {
    var userLogin = ParseUser(email, password, email);
    userLogin.login().then((value) {
      if (value.success) {
        ParseUser parseUser = value.result;
        BaseUser user = BaseUser.fromMap(parseUser.toJson());
        PreferencesUtil.setUserData(user.toMap());
        presenter.onSuccess(user);
      } else {
        switch (value.error.code) {
          case -1:
            presenter.onFailure(ERROR_NETWORK);
            break;
          case 101:
            presenter.onFailure(ERROR_LOGIN_PASSWORD);
            break;
          default:
            presenter.onFailure(value.error.message);
        }
      }
    }).catchError((error) {
      Log.e(error);
      presenter.onFailure(error.message);
    });
  }

  @override
  signInWithGoogle() {

  }

}