import 'package:kideliver/strings.dart';

import '../../models/company/type_payment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../page_router.dart';

class PaymentTypePage extends StatefulWidget {
  final List<TypePayment> paymentsType;

  PaymentTypePage({
    this.paymentsType,
  });

  @override
  _PaymentTypePageState createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: Text(PAYMENT_TYPE, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textTitleWidget(),
          paymentListView(),
        ],
      ),
    );
  }

  Widget textTitleWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        "Pagar na entrega",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget paymentListView() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: widget.paymentsType.map((e) {
        return paymentListItem(e);
      }).toList(),
    );
  }

  Widget paymentListItem(TypePayment payment) {
    IconData icon = findIcon(payment.paymentType);
    String name = payment.getType();
    return Card(
      child: FlatButton(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: FaIcon(icon, color: Colors.green,),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              Container(
                child: Checkbox(
                  value: false,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          PageRouter.pop(context, payment);
        },
      ),
    );
  }

  IconData findIcon(Type type) {
    IconData icon;
    switch(type) {
      case Type.MONEY:
        icon = FontAwesomeIcons.moneyBill;
        break;
      case Type.CARD:
        icon = FontAwesomeIcons.creditCard;
        break;
      case Type.APP_PAYMENT:
        icon = FontAwesomeIcons.mobileAlt;
        break;
      case Type.CASHBACK:
        icon = FontAwesomeIcons.handHoldingUsd;
        break;
    }
    return icon;
  }
  

}
