import 'package:delivery/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../../widgets/empty_list_widget.dart';
import '../../strings.dart';

class ConfirmOrderPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confirmar Pedido", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: keyboardDismisser(),
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
      child: Column(
        children: [
          companyWidget(),
          deliveryStreetWidget(),
          typePaymentWidget(),
          sendOrderWidget(),
        ],
      ),
    );
  }

  Widget companyWidget() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Card(

      ),
    );
  }

  Widget deliveryStreetWidget() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Card(

      ),
    );
  }

  Widget typePaymentWidget() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Card(

      ),
    );
  }

  Widget sendOrderWidget() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: PrimaryButton(
        text: "Enviar pedido",
        onPressed: () {

        },
      ),
    );
  }

}