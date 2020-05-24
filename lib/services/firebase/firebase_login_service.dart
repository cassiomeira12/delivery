import '../../contracts/login/login_contract.dart';
import '../../models/base_user.dart';
import '../../services/firebase/firebase_user_service.dart';
import '../../utils/log_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../strings.dart';
import '../../contracts/crud.dart';

class FirebaseLoginService extends LoginContractService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseLoginService(LoginContractPresenter presenter) : super(presenter);

  @override
  signIn(String email, String password) async {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((AuthResult result) async {
      Crud<BaseUser> crud = FirebaseUserService("users");
      List<BaseUser> list =  await crud.findBy("email", email);

      if (list == null) {
        return presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

      if (list.length == 1) {
        BaseUser user = list[0];
        if (!user.emailVerified) { // Verificando se o email do usuario foi validado
          user.emailVerified = result.user.isEmailVerified; // Atualizando caso o email ja foi validado
          crud.update(user); // Atualizando a base de dados
        }
        presenter.onSuccess(user);
      } else if (list.length == 0) {
        _firebaseAuth.signOut();
        presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

    }).catchError((error) {
      Log.e(error);
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          presenter.onFailure(USUARIO_NAO_ENCONTRADO);
          break;
        case "ERROR_WRONG_PASSWORD":
          presenter.onFailure(SENHA_INVALIDA);
          break;
        default:
          presenter.onFailure(error.message);
      }
    });
  }

  @override
  signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount;
    GoogleSignInAuthentication googleSignInAuthentication;
    AuthCredential credential;
    try {
      googleSignInAccount = await googleSignIn.signIn();
      googleSignInAuthentication = await googleSignInAccount.authentication;
      credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
    } catch (exception) {
      Log.e(exception);
      presenter.onFailure("Verifique a chave SHA1 no Firebase");
      return;
    }
    await _firebaseAuth.signInWithCredential(credential).then((AuthResult result) async {
      Crud<BaseUser> crud = FirebaseUserService("users");
      List<BaseUser> list = await crud.findBy("email", result.user.email);

      if (list == null) {
        return presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

      if (list.length == 1) {
        BaseUser user = list[0];
        if (!user.emailVerified) { // Verificando se o email do usuario foi validado
          user.emailVerified = result.user.isEmailVerified; // Atualizando caso o email ja foi validado
          crud.update(user); // Atualizando a base de dados
        }
        presenter.onSuccess(user);
      } else if (list.length == 0) {//Nova conta
        var user = BaseUser()
          ..name = result.user.displayName
          ..email = result.user.email
          ..emailVerified = result.user.isEmailVerified
          ..avatarURL = result.user.photoUrl
          ..createAt = DateTime.now();

        Crud<BaseUser> crud = FirebaseUserService("users");
        user = await crud.create(user);
        if (result == null) {
          presenter.onFailure(ERROR_CRIAR_USUARIO);
        } else {
          presenter.onSuccess(user);
        }
      }

    }).catchError((error) {
      print(error.message);
      presenter.onFailure(error.message);
    });
  }

}