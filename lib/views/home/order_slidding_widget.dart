import 'package:delivery/models/order/order_item.dart';
import 'package:delivery/models/singleton/order_singleton.dart';
import 'package:delivery/views/home/confirm_order_page.dart';
import 'package:delivery/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../strings.dart';
import '../page_router.dart';

class OrderSliddingWidget extends StatefulWidget {
  final VoidCallback orderCallback, updateOrders;
  _OrderSliddingWidgetState _page;
  bool _initedState = false;

  OrderSliddingWidget({
    @required this.orderCallback,
    this.updateOrders,
  });

  void listItens() {
    if (_initedState) {
      _page.listItens();
    }
  }

  @override
  _OrderSliddingWidgetState createState() => _page = _OrderSliddingWidgetState();
}

class _OrderSliddingWidgetState extends State<OrderSliddingWidget> {

  List<OrderItem> listOrder = List();
  double total = 0;
  double deliveryCost;

  @override
  void initState() {
    super.initState();
    print("Slidding init");
    widget._initedState = true;
    //deliveryCost = OrderSingleton.instance.company.delivery.cost / 100;
    listItens();
  }

  @override
  void dispose() {
    super.dispose();
    widget._initedState = false;
    print("slidding dispose");
  }

  void listItens() {
    if (OrderSingleton.instance.id != null) {
      //total = deliveryCost;
      total = 0;
      setState(() {
        listOrder = OrderSingleton.instance.items;
      });
      listOrder.forEach((element) {
        total += element.getTotal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: textTitle(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 80),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listViewOrder(),
                  //textDelivery(),
                  textCost(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: deliveryButton(),
          ),
        ],
      ),
    );
  }

  Widget textTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
      child: Text(
        "Pedidos selecionados",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 30,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
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
          return listItem(e);
        }).toList(),
      ),
    );
  }

  Widget listItem(OrderItem item) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: itemOrder(item),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: DELETAR,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            setState(() {
              listOrder.remove(item);
              listItens();
              if (listOrder.isEmpty) {
                OrderSingleton.instance.clear();
              }
              widget.updateOrders();
            });
          },
        ),
      ],
    );
  }

  Widget itemOrder(OrderItem item) {
    return Card(
      margin: EdgeInsets.only(top: 1),
      elevation: 0,
      color: Colors.grey[200],
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
                      "R\$ ${item.getTotal().toStringAsFixed(2)}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
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
            "R\$ ${deliveryCost.toStringAsFixed(2)}",
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
            "Subtotal",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "R\$ ${total.toStringAsFixed(2)}",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget deliveryButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: PrimaryButton(
        text: "Escolher endereço",
        onPressed: () async {
          var result = await PageRouter.push(context, ConfirmOrderPage(orderCallback: widget.orderCallback,));
          if (result != null) {
            PageRouter.pop(context);
          }
        },
      ),
    );
  }

}
