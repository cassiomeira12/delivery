import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../../../models/phone_number.dart';
import '../../../services/api/required_company_service.dart';
import '../../../models/singleton/singletons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import '../../../contracts/login/login_contract.dart';
import '../../../presenters/login/login_presenter.dart';
import '../../../views/settings/phone_number_page.dart';
import '../../../widgets/scaffold_snackbar.dart';
import '../../../widgets/text_input_field.dart';
import '../../../models/base_user.dart';
import '../../../strings.dart';
import '../../../widgets/background_card.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/shape_round.dart';
import '../../page_router.dart';

class NewCompanyPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _NewCompanyPageState();
}

class _NewCompanyPageState extends State<NewCompanyPage> implements LoginContractView{
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginContractPresenter presenter;
  bool _loading = false;

  var phoneNumberController = MaskedTextController(mask: '(00) 0 0000-0000');
  String _name;
  String _email;
  String _phoneNumber;
  String _companyName;
  String _cityName;

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
            phoneNumberInput(),
            companyInput(),
            cityInput(),
            textData(),
            sendButton(),
          ],
        ),
      ),
    );
  }

  Widget textTitle() {
    return Center(
      child: Text(
        "Cadastro",
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: "Nome completo",
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

  Widget phoneNumberInput () {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: TextInputField(
        controller: phoneNumberController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        labelText: "Telefone para contato",
        hintText: "(XX) X XXXX-XXXX",
        validator: (value) => value.isEmpty ? DIGITE_NUMERO_TELEFONE : null,
        onSaved: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget companyInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: "Nome do estabelecimento",
        textCapitalization: TextCapitalization.words,
        onSaved: (value) => _companyName = value.trim(),
      ),
    );
  }

  Widget cityInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextInputField(
        labelText: "Cidade",
        textCapitalization: TextCapitalization.words,
        onSaved: (value) => _cityName = value.trim(),
      ),
    );
  }

  Widget textData() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: Center(
        child: Text(
          "Ao enviar a solicitação de cadastro nós entraremos em contato com você.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  Widget sendButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: PrimaryButton(
        text: ENVIAR,
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

  bool validateData() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  PhoneNumber createPhoneNumber(String phoneNumber) {
    PhoneNumber phone = PhoneNumber();
    phone.countryCode = "+55";
    phone.ddd = _phoneNumber.substring(1, 3);
    phone.number = _phoneNumber.substring(5);
    return phone;
  }

  void createAccount() async {
    if (validateData()) {
      var phoneNumber = createPhoneNumber(_phoneNumber);
      var requiredCompany = {
        "name": _name,
        "email": _email,
        "phoneNumber": phoneNumber.toMap(),
        "companyName": _companyName,
        "cityName": _cityName
      };
      var result = await RequiredCompanyService().send(requiredCompany);
      if (result) {
        ScaffoldSnackBar.success(context, _scaffoldKey, "Cadastro de estabelecimento enviado com sucesso!");
      } else {
        ScaffoldSnackBar.failure(context, _scaffoldKey, SOME_ERROR);
      }
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

  }

  @override
  onSuccess(BaseUser result) async {

  }

  @override
  listSuccess(List<BaseUser> list) {

  }

}
