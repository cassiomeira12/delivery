import '../../models/singleton/singletons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../contracts/login/login_contract.dart';
import '../../presenters/login/login_presenter.dart';
import '../../views/settings/phone_number_page.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/text_input_field.dart';
import '../../models/base_user.dart';
import '../../strings.dart';
import '../../views/login/create_account_page.dart';
import '../../widgets/background_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/shape_round.dart';

import '../page_router.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({this.loginCallback});

  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> implements LoginContractView{
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginContractPresenter presenter;
  bool _loading = false;

  String _name;
  String _email;
  String _password;

  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar( iconTheme: IconThemeData(color: Colors.white), elevation: 0,),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
          child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(),),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              BackgroundCard(),
              Column(
                children: [
                  ShapeRound(
                      _showForm()
                  ),
                  //textOU(),
                  //googleButton(),
                ],
              ),
            ],
          ),
        ),
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
            textTitle(),
            nameInput(),
            emailInput(),
            passwordInput(),
            confirmPasswordInput(),
            textData(),
            createAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget textTitle() {
    return Center(
      child: Text(
        CRIAR_CONTA,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: NOME,
        textCapitalization: TextCapitalization.words,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: TextInputField(
        labelText: EMAIL,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: SENHA,
        obscureText: true,
        validator: (value) {
          if (value.isEmpty || value.length < 6) {
            return SENHA_MUITO_CURTA;
          }
          _password = value;
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget confirmPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: REPITA_SENHA,
        obscureText: true,
        validator: (value) {
          if (value.isEmpty || value.length < 6) {
            return SENHA_MUITO_CURTA;
          }
          if (_password != value) {
            return SENHA_NAO_SAO_IGUAIS;
          }
          return null;
        },
      ),
    );
  }

  Widget textData() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: Center(
        child: Text(
          TEXT_DADOS,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  Widget createAccountButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: PrimaryButton(
        text: CRIAR_CONTA,
        onPressed: createAccount,
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
      padding: EdgeInsets.fromLTRB(60, 12, 60, 20),
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
                  "Usar conta do Google",
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
          presenter.signInWithGoogle();
        },
      ),
    );
  }

  bool validateData() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  BaseUser createBaseUser() {
    BaseUser user = BaseUser();
    user.name = _name;
    user.username = _email;
    user.email = _email;
    user.password = _password;
    return user;
  }

  void createAccount() async {
    if (validateData()) {
      var user = createBaseUser();
      await PageRouter.push(context, CreateAccountPage(loginCallback: widget.loginCallback, user: user,));
      PageRouter.pop(context);
    }
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
    if (result.phoneNumber == null) {
      var phoneNumber = await PageRouter.push(context, PhoneNumberPage(authenticate: false,));
      Singletons.user().phoneNumber = phoneNumber;
    }
    widget.loginCallback();
    PageRouter.pop(context);
  }

  @override
  listSuccess(List<BaseUser> list) { }

}
