import '../../widgets/area_input_field.dart';
import '../../contracts/address/address_contract.dart';
import '../../models/address/address.dart';
import '../../models/address/city.dart';
import '../../models/address/small_town.dart';
import '../../models/singleton/singleton_user.dart';
import '../../presenters/address/address_presenter.dart';
import '../../strings.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../page_router.dart';

class NewAddressPage extends StatefulWidget {
  final City city;
  final SmallTown smallTown;

  NewAddressPage({
    this.city,
    this.smallTown,
  });

  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> implements AddressContractView {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String bairro, rua, numero, referencia;

  AddressContractPresenter presenter;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    presenter = AddressPresenter(this);
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
      appBar: AppBar(
        title: Text("Novo Endereço", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        progressIndicator: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
          child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(),),
        ),
        child: body(),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.city != null ? textCityWidget() : Container(),
          widget.smallTown == null ? Container() : textDistritoWidget(),
          widget.smallTown == null ? cityForm() : smallTomForm(),
          saveButton(),
        ],
      ),
    );
  }

  Widget cityForm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            textInputNeighborhood(),
            textInputStreet(),
            textInputNumber(),
            textInputReference(),
          ],
        ),
      ),
    );
  }

  Widget smallTomForm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //textSmallAddress(),
            textInputStreet(),
            textInputNumber(),
            textInputReference(),
          ],
        ),
      ),
    );
  }

  Widget textCityWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "${widget.city.name}-${widget.city.codeState}",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget textDistritoWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        widget.smallTown.name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget textInputNeighborhood() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextInputField(
        labelText: "Bairro",
        textCapitalization: TextCapitalization.sentences,
        onSaved: (value) => bairro = value.trim(),
      ),
    );
  }

  Widget textInputStreet() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextInputField(
        labelText: "Rua",
        textCapitalization: TextCapitalization.sentences,
        onSaved: (value) => rua = value.trim(),
      ),
    );
  }

  Widget textInputNumber() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextInputField(
        labelText: "Número",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) => null,
        onSaved: (value) => numero = value.trim(),
      ),
    );
  }

  Widget textInputReference() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: AreaInputField(
        labelText: "Referência",
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        validator: (value) => null,
        onSaved: (value) => referencia = value.trim(),
      ),
    );
  }

  Widget textSmallAddress() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextInputField(
        labelText: "Endereço",
        textCapitalization: TextCapitalization.sentences,
        onSaved: (value) => rua = value.trim(),
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: PrimaryButton(
        text: SALVAR,
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

  void validateAndSubmit() {
    if (validateAndSave()) {
      var address = create();
      setState(() {
        loading = true;
      });
      presenter.create(address);
    }
  }

  Address create() {
    Address address = Address()
      ..userId = SingletonUser.instance.id
      ..neighborhood = bairro
      ..street = rua
      ..number = numero.isEmpty ? null : numero
      ..reference = referencia.isEmpty ? null : referencia;
    address.city = widget.city;
    address.smallTown = widget.smallTown;
    return address;
  }

  @override
  listSuccess(List<Address> list) {

  }

  @override
  onFailure(String error)  {
    setState(() {
      loading = false;
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(Address result) {
    setState(() {
      loading = false;
    });
    PageRouter.pop(context, result);
  }

}
