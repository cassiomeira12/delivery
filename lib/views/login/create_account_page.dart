import 'package:flutter/material.dart';
import '../../models/singleton/singletons.dart';
import '../../widgets/loading_widget.dart';
import '../../contracts/login/create_account_contract.dart';
import '../../models/base_user.dart';
import '../../presenters/login/create_account_presenter.dart';
import '../../widgets/background_card.dart';
import '../../widgets/shape_round.dart';
import '../../strings.dart';
import '../page_router.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({this.loginCallback, this.user});

  final VoidCallback loginCallback;
  final BaseUser user;

  @override
  State<StatefulWidget> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> implements CreateAccountContractView {
  CreateAccountContractPresenter presenter;

  bool _isLoading = false;
  String _textMessage = ESTAMOS_CRIANDO_CONTA;
  String _imgURL = "";

  @override
  void initState() {
    super.initState();
    presenter = CreateAccountPresenter(this);
    presenter.createAccount(widget.user);
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            BackgroundCard(),
            SingleChildScrollView(
              child: ShapeRound(
                  _showForm()
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Form(
        //key: _formKey,
        child: Column(
          children: <Widget>[
            textTitle(),
            _isLoading ? LoadingWidget() : imagem(), textMensagem(),
          ],
        ),
      ),
    );
  }

  Widget textTitle() {
    return Center(
      child: Text(
        CRIANDO_CONTA,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

  Widget imagem() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70.0,
          child: Image.asset(_imgURL),
        ),
      ),
    );
  }

  Widget textMensagem() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: Center(
        child: Text(
          _textMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  @override
  hideProgress() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  showProgress() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  onSuccess(BaseUser user) async {
    setState(() {
      _imgURL = "assets/sucesso.png";
      _textMessage = CONTA_CRIADA_SUCESSO;
    });
    Singletons.user().updateData(user);
    await Future.delayed(const Duration(seconds: 2));
    PageRouter.pop(context);
    widget.loginCallback();
  }

  @override
  onFailure(String error) {
    setState(() {
      _imgURL = "assets/error.png";
      _textMessage = error;
    });
  }

  @override
  listSuccess(List<BaseUser> list) { }

}