import 'package:kideliver/models/order/cupon.dart';
import 'package:kideliver/utils/log_util.dart';
import 'package:kideliver/widgets/scaffold_snackbar.dart';

import '../../services/api/cupon_service.dart';
import '../../contracts/user/user_contract.dart';
import '../../models/singleton/singletons.dart';
import '../../presenters/user/user_presenter.dart';
import '../../utils/preferences_util.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import '../../models/phone_number.dart';
import '../../strings.dart';
import '../../widgets/background_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/shape_round.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../page_router.dart';

class CheckCuponPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CheckCuponPageState();
}

class _CheckCuponPageState extends State<CheckCuponPage> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _code;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
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
              bodyAppScrollView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyAppScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
            child: ShapeRound(_showForm(context)),
          ),
        ],
      ),
    );
  }

  Widget _showForm(context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            textTitle(),
            textMessage(),
            cuponInput(),
            checkCuponCode(),
          ],
        ),
      ),
    );
  }

  Widget textTitle() {
    return Center(
      child: Text(
        "Cupom",
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

  Widget textMessage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
      child: Center(
        child: Text(
          "Adicione aqui o seu cupom de desconto",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  Widget cuponInput () {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: TextInputField(
        textAlign: TextAlign.center,
        labelText: "Código do cupom",
        onSaved: (value) => _code = value.trim(),
      ),
    );
  }

  Widget checkCuponCode() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: PrimaryButton(
        text: "Aplicar",
        onPressed: validateAndSubmit,
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      Cupon result;
      try {
        setState(() => _loading = true);
        result = await CuponService().check(_code, user: Singletons.user(), company: Singletons.order().company);
        ScaffoldSnackBar.success(context, _scaffoldKey, "Cupom adicionado com sucesso!");
      } catch(error) {
        ScaffoldSnackBar.failure(context, _scaffoldKey, error.message);
      } finally {
        setState(() => _loading = false);
        if (result != null) {
          await Future.delayed(Duration(seconds: 1));
          PageRouter.pop(context, result);
        }
      }
    }
  }

}