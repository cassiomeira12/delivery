import 'package:adaptive_dialog/adaptive_dialog.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/address/address.dart';
import '../../models/company/type_payment.dart';
import '../../models/order/order.dart';
import '../../models/order/order_item.dart';
import '../../models/singleton/order_singleton.dart';
import '../../models/singleton/singleton_user.dart';
import '../../presenters/order/order_presenter.dart';
import '../../utils/log_util.dart';
import '../../views/home/delivery_address_page.dart';
import '../../views/home/payment_type_page.dart';
import '../../widgets/area_input_field.dart';
import '../../widgets/image_network_widget.dart';
import '../../widgets/light_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_shape.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../strings.dart';
import '../page_router.dart';

class ConfirmOrderPage extends StatefulWidget {
  final VoidCallback orderCallback;

  ConfirmOrderPage({
    @required this.orderCallback
  });

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> implements OrderContractView {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderContractPresenter presenter;

  TextEditingController _observacaoController;

  Address deliveryAddress;
  TypePayment typePayment;

  double total = 0;
  double deliveryCost = 0;
  List<OrderItem> listOrder = List();

  bool pickup = false;

  List<bool> _selections = [true, false];

  @override
  void initState() {
    super.initState();
    presenter = OrdersPresenter(this);
    _observacaoController = TextEditingController();
    deliveryCost = OrderSingleton.instance.company.delivery.cost/100;
    setState(() {
      listOrder.addAll(OrderSingleton.instance.items);
    });
    listOrder.forEach((element) {
      total += element.getTotal();
    });
  }

  @override
  listSuccess(List<Order> list) {
    print(list);
  }

  @override
  onFailure(String error) {
    print(error);
  }

  @override
  onSuccess(Order result) {
    OrderSingleton.instance.id = result.id;
    widget.orderCallback();
    PageRouter.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confirmar pedido", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          cardCompany(),
          SizedBox(height: 10,),
          cardDeliveryAddress(),
          SizedBox(height: 10,),
          cardPaymentType(),
          SizedBox(height: 40,),
          sendOrderButton(),
        ],
      ),
    );
  }

  Widget cardCompany() {
    return Card(
      elevation: 1,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageUser(OrderSingleton.instance.company.logoURL),
                  textCompanyWidget(),
                ],
              ),
              listViewOrder(),
              !pickup ? textDelivery() : Container(),
              textCost(),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageUser(String url) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Theme.of(context).hintColor,
            ),
          ),
          child: url == null ?
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Image.asset("assets/logo_app.png"),
          )
              :
          Container(),
        ),
        url == null ? Container() : ImageNetworkWidget(url: url, size: 68,),
      ],
    );
  }

  Widget textCompanyWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(
        "Point Luca",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget textDelivery() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Taxa de entrega",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            deliveryCost == 0 ? "Grátis" : "R\$ ${(deliveryCost).toStringAsFixed(2)}",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget textCost() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            pickup ? "R\$ ${total.toStringAsFixed(2)}" : "R\$ ${(total + deliveryCost).toStringAsFixed(2)}",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewOrder() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: listOrder.map((e) {
          return itemOrder(e);
        }).toList(),
      ),
    );
  }

  Widget itemOrder(OrderItem item) {
    return Card(
      margin: EdgeInsets.only(top: 1),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 18, 10, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.amount}x ${item.name}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "R\$ ${(item.amount * item.cost).toStringAsFixed(2)}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: item.choicesSelected.map((choice) {
                return Text(
                  "* $choice",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    //fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: item.additionalSelected.map((additional) {
                return Text(
                  "+ ${additional.amount} ${additional.name} R\$ ${(additional.amount * additional.cost).toStringAsFixed(2)}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    //fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            item.note.isNotEmpty ?
            Text(
              item.note,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                //fontWeight: FontWeight.bold,
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget cardDeliveryAddress() {
    return Card(
      elevation: 1,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textDeliveryAddress(),
                  OrderSingleton.instance.company.delivery.pickup ?
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: typeDeliveryButtons(),
                  ) : Container(),
                  deliveryAddressWidget(),
                ],
              ),
            ),
          ),
          observacaoDelivery(),
          SizedBox(height: 5,),
        ],
      ),
    );
  }

  Widget typeDeliveryButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: ToggleButtons(
        isSelected: _selections,
        selectedColor: Theme.of(context).backgroundColor,
        fillColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.motorcycle,),
                SizedBox(width: 10,),
                Text(
                  "Entrega",
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.running,),
                SizedBox(width: 10,),
                Text(
                  "Retirada",
                ),
              ],
            ),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            if (index == 0 && pickup) {
              _selections[index] = true;
              _selections[index + 1] = false;
              pickup = false;
            } else if (index == 1 && !pickup) {
              _selections[index] = true;
              _selections[index - 1] = false;
              pickup = true;
            }
          });
        },
      ),
    );
  }

  Widget deliveryAddressWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/fundo_mapa.png"),
        ),
        addressWidget(),
      ],
    );
  }

  Widget addressWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, right: 10),
                  child: Text(
                    pickup ? "Buscar em" : "Entregar em",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                 !pickup && (deliveryAddress == null) ?
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 15),
                    child: Text(
                      "Adicione aqui o local para entrega",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ) : addressDataWidget( deliveryAddress == null ? OrderSingleton.instance.company.address : deliveryAddress ),

                pickup ?
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                    child: Text(
                      "Abrir o Mapa",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ) : deliveryAddress == null ?
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RoundedShape(
                        padding: EdgeInsets.all(15),
                        color: Colors.transparent,
                        child: Text(
                          "Escolher local",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    ) : Container(),

              ],
            ),
          ),
          onPressed: () async {
            if (pickup) {
              var address =  OrderSingleton.instance.company.address;
              var mapSchema = 'geo:${address.location["lat"]},${address.location["long"]}';
              if (await canLaunch(mapSchema)) {
                await launch(mapSchema);
              }
            } else {
              Address companyAddress = OrderSingleton.instance.company.address;
              Address result = await PageRouter.push(context, DeliveryAddressPage(address: companyAddress,));
              if (result != null) {
                setState(() {
                  deliveryAddress = result;
                });
              }
            }
          },
        ),
      ),
    );
  }

  Widget textDeliveryAddress() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Local de entrega",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget addressDataWidget(Address address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Text(
            address.city.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
        ),
        address.smallTown != null ?
          Padding(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
            child: Text(
              address.smallTown.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          ) : Container(),
        //SizedBox(height: 5,),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Text(
            "${address.street}" + (address.number == null ? "" : ", ${address.number}"),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
        ),
        address.neighborhood != null ? Padding(
          padding: EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Text(
            address.neighborhood,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
        ) : Container(),
        address.reference != null ? Padding(
          padding: EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Text(
            address.reference,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black38,
            ),
          ),
        ) : Container(),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget cardPaymentType() {
    return Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Forma de pagamento",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              typePayment == null ?
              Padding(
                padding: EdgeInsets.all(20),
                child: SecondaryButton(
                  text: "Escolher Pagamento",
                  onPressed: () async {
                    var companyPayments = OrderSingleton.instance.company.typePayments;
                    TypePayment result = await PageRouter.push(context, PaymentTypePage(paymentsType: companyPayments,));
                    await Future.delayed(Duration(milliseconds: 300));
                    if (result != null) {
                      if (result.type == Type.MONEY) {
                        OrderSingleton.instance.changeMoney = await getTroco();
                      }
                    }
                    setState(() {
                      if (result != null) {
                        typePayment = result;
                      }
                    });
                  },
                ),
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  paymentTypeWidget(typePayment),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      OrderSingleton.instance.changeMoney == null ? "Sem troco" : "Troco para ${OrderSingleton.instance.changeMoney}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentTypeWidget(TypePayment payment) {
    IconData icon = findIcon(payment.type);
    String name = payment.getType();
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 15, 5, 0),
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
            LightButton(
              text: "Trocar",
              onPressed: () async {
                var companyPayments = OrderSingleton.instance.company.typePayments;
                TypePayment result = await PageRouter.push(context, PaymentTypePage(paymentsType: companyPayments,));
                await Future.delayed(Duration(milliseconds: 300));
                if (result != null) {
                  if (result.type == Type.MONEY) {
                    OrderSingleton.instance.changeMoney = await getTroco();
                  }
                }
                setState(() {
                  if (result != null) {
                    typePayment = result;
                  }
                });
              },
            ),
          ],
        ),
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

  Future<String> getTroco() async {
    var result = await showTextInputDialog(
      context: context,
      title: "Precisa de troco?",
      message: "Troco pra quanto ?",
      cancelLabel: "Sem troco",
      okLabel: SALVAR,
      textFields: [
        DialogTextField(
          hintText: "Ex: 20 reais",
        ),
      ],
    );
    return result == null ? null : result[0];
  }

  Widget observacaoDelivery() {
    return GestureDetector(
      child: AbsorbPointer(
        absorbing: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: AreaInputField(
            labelText: "Observação para entrega",
            maxLines: 4,
            controller: _observacaoController,
          ),
        ),
      ),
      onTap: () async {
        var result = await showTextInputDialog(
          context: context,
          title: "Observação",
          message: "Digite aqui sua observação",
          cancelLabel: CANCELAR,
          okLabel: SALVAR,
          textFields: [
            DialogTextField(
              hintText: "Observação",
              initialText: _observacaoController.text,
            ),
          ],
        );
        if (result == null) return;
        var temp = result[0];
        setState(() {
          _observacaoController.text = temp;
        });
      },
    );
  }

  bool checkDelevieryAddress() {
    return pickup ? true : deliveryAddress != null;
  }

  bool checkPaymentType() {
    return typePayment != null;
  }

  Widget sendOrderButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: PrimaryButton(
        text: "Enviar Pedido",
        onPressed: () {

          if (checkDelevieryAddress()) {
            if (pickup) {
              var companyAddress = OrderSingleton.instance.company.address;
              OrderSingleton.instance.deliveryAddress = companyAddress;
            } else {
              OrderSingleton.instance.deliveryAddress = deliveryAddress;
            }
          } else {
            ScaffoldSnackBar.failure(context, _scaffoldKey, "Escolha um local para entrega!");
            return;
          }

          if (checkPaymentType()) {
            OrderSingleton.instance.typePayment = typePayment;
          } else {
            ScaffoldSnackBar.failure(context, _scaffoldKey, "Escolha uma forma de pagamento!");
            return;
          }

          OrderSingleton.instance.id = null;
          OrderSingleton.instance.createdAt = DateTime.now();
          OrderSingleton.instance.status.values[0].date = DateTime.now();
          OrderSingleton.instance.status.current = OrderSingleton.instance.status.values[0];
          OrderSingleton.instance.note = _observacaoController.text;

          if (pickup) {
            OrderSingleton.instance.deliveryCost = 0;
          } else {
            OrderSingleton.instance.deliveryCost = deliveryCost;
          }

          Log.d(OrderSingleton.instance.toMap());
          presenter.create(OrderSingleton.instance);
        },
      ),
    );
  }

}
