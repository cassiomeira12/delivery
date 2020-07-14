import 'package:auto_size_text/auto_size_text.dart';
import '../../contracts/user/user_contract.dart';
import '../../presenters/user/user_presenter.dart';
import '../../utils/preferences_util.dart';
import '../../models/singleton/singletons.dart';
import '../../views/settings/phone_number_page.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../widgets/text_input_field.dart';
import '../../contracts/login/login_contract.dart';
import '../../models/base_user.dart';
import '../../presenters/login/login_presenter.dart';
import '../../views/page_router.dart';
import '../../widgets/background_card.dart';
import '../../widgets/light_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/shape_round.dart';
import '../../strings.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;
  final bool anonymousLogin;

  LoginPage({
    this.loginCallback,
    this.anonymousLogin = false,
  });

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  LoginContractPresenter loginPresenter;
  UserContractPresenter userPresenter;

  String _email;
  String _password;

  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginPresenter = LoginPresenter(this);
    userPresenter = UserPresenter(null);
    if (Singletons.user().id != null) {
      controller.text = Singletons.user().email;
    }
  }

  @override
  void dispose() {
    super.dispose();
    loginPresenter.dispose();
    userPresenter.dispose();
  }

  @override
  hideProgress() {
    setState(() => _loading = false);
  }

  @override
  showProgress() {
    setState(() => _loading = true);
  }

  @override
  onFailure(String error) {
    hideProgress();
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(BaseUser result) async {
    Singletons.user().updateData(result);
    if (result.emailVerified) {
      if (result.phoneNumber == null && !result.isAnonymous()) {
        await PageRouter.push(context, PhoneNumberPage(authenticate: false,));
      }
    }
    if (widget.anonymousLogin) {
      await updateNotificationToken();
      PageRouter.pop(context);
    } else {
      widget.loginCallback();
    }
  }

  Future<void> updateNotificationToken() async {
    var notificationToken = await Singletons.pushNotification().updateNotificationToken();
    Singletons.user().notificationToken = notificationToken;
    PreferencesUtil.setUserData(Singletons.user().toMap());
    userPresenter.update(Singletons.user());
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
          child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(),),
        ),
        child: keyboardDismisser(),
      ),
    );
  }

  Widget keyboardDismisser() {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onVerticalDragDown
      ],
      child: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          BackgroundCard(),
          bodyAppScrollView(),
        ],
      ),
    );
  }

  Widget bodyAppScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ShapeRound(
              _showForm()
          ),
          textOU(),
          //googleButton(),
          signupButton(),
          anonymousButton(),
        ],
      ),
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showForgotPasswordButton(),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget showLogo() {
    return Column(
      children: <Widget>[
        Hero(
          tag: APP_NAME,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 58.0,
              child: Image.asset("assets/logo_app.png"),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          APP_NAME,
          style: Theme.of(context).textTheme.body1,
        ),
      ],
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: EMAIL,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: SENHA,
        keyboardType: TextInputType.text,
        obscureText: true,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showForgotPasswordButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: LightButton(
        alignment: Alignment.bottomRight,
        text: RECUPERAR_SENHA,
        onPressed: () {
          PageRouter.push(context, ForgotPasswordPage());
        },
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: PrimaryButton(
        text: ENTRAR,
        onPressed: validateAndSubmit,
      ),
    );
  }

  Widget textOU() {
    return Text(
      "--- $OU ---",
      style: Theme.of(context).textTheme.body2,
    );
  }

  Widget googleButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(60, 12, 60, 0),
      child: SecondaryButton(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/google_logo.png",
                  width: 25,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                  LOGAR_COM_GOOGLE,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        onPressed: () {
          loginPresenter.signInWithGoogle();
        },
      ),
    );
  }

  Widget signupButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(60, 12, 60, 0),
      child: SecondaryButton(
        text: CRIAR_CONTA,
        onPressed: () async {
          await PageRouter.push(context, SignUpPage(loginCallback: widget.loginCallback,));
          if (Singletons.user().id != null) {
            controller.text = Singletons.user().email;
          }
        },
      ),
    );
  }

  Widget anonymousButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 12, 10, 30),
      child: LightButton(
        text: "Entrar como convidado".toUpperCase(),
        onPressed: () {
          loginPresenter.signAnonymous();
        },
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() {
    if (validateAndSave()) {
      loginPresenter.signIn(_email, _password);
    }
  }

  @override
  listSuccess(List<BaseUser> list) { }

}