import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../../utils/log_util.dart';
import '../../utils/preferences_util.dart';
import '../../contracts/crud.dart';
import '../../services/parse/parse_user_service.dart';
import '../../contracts/login/create_account_contract.dart';
import '../../models/base_user.dart';

class ParseCreateAccountService implements CreateAccountContractService {
  CreateAccountContractPresenter presenter;

  ParseCreateAccountService(this.presenter);

  @override
  dispose() {
    presenter = null;
  }

  @override
  Future<BaseUser> createAccount(BaseUser item) async {
    Crud<BaseUser> crud = ParseUserService();
    crud.create(item).then((newUser) async {
      var userLogin = ParseUser(item.username, item.password, item.password);
      userLogin.login().then((value) {
        ParseUser parseUser = value.result;
        BaseUser user = BaseUser.fromMap(parseUser.toJson());
        PreferencesUtil.setUserData(user.toMap());
        presenter.onSuccess(user);
      });
    }).catchError((error) {
      presenter.onFailure(error.message);
    });
  }

}