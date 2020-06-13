import 'package:delivery/views/historico/evalutation_dialog.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/address/address.dart';
import '../../models/order/order.dart';
import '../../models/order/order_item.dart';
import '../../models/order/order_status.dart';
import '../../presenters/order/order_presenter.dart';
import '../../utils/date_util.dart';
import '../../widgets/stars_widget.dart';
import 'package:flutter/material.dart';

import '../page_router.dart';

class HistoricOrderPage extends StatefulWidget {
  final Order item;

  HistoricOrderPage({
    this.item,
  });

  @override
  State<StatefulWidget> createState() => _HistoricOrderPageState();
}

class _HistoricOrderPageState extends State<HistoricOrderPage> implements OrderContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  OrdersPresenter presenter;

  Order order;
  double total = 0;

  List<Widget> ordersItems;
  int currentStatusIndex = 0;
  List<Widget> statusItems = List();

  @override
  void initState() {
    super.initState();
    presenter = OrdersPresenter(this);
    this.order = widget.item;
    total = order.deliveryCost;
    order.items.forEach((element) {
      total += element.getTotal();
    });
    ordersItems = order.items.map((e) => orderItem(e)).toList();
    int index = 0;
    order.status.values.forEach((element) {
      if (element.name == order.status.current.name) {
        currentStatusIndex = index;
        return;
      }
      index++;
    });
    presenter.readSnapshot(order);
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  @override
  listSuccess(List<Order> list) {

  }

  @override
  onFailure(String error)  {
    print(error);
  }

  @override
  onSuccess(Order result) {
    order.update(result);
    int index = 0;
    order.status.values.forEach((element) {
      if (element.name == order.status.current.name) {
        setState(() {
          currentStatusIndex = index;
        });
        return;
      }
      index++;
    });
    checkEvalutationOrder();
  }

  void checkEvalutationOrder() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (order.status.isLast() && order.evaluation == null) {
      var evaluation = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => EvaluationDialog(),
      );
      if (evaluation != null) {
        setState(() {
          order.evaluation = evaluation;
        });
        presenter.update(order);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Pedido", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: nestedScrollView(),
    );
  }

  Widget nestedScrollView() {
    return NestedScrollView(
      controller: ScrollController(keepScrollOffset: true),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      nestedHeader(),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ];
      },
      body: body(),
    );
  }

  Widget nestedHeader() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleTextWidget(order.companyName),
                dateTextWidget(DateUtil.formatDateCalendar(order.createdAt)),
              ],
            ),
            SizedBox(height: 5,),
            Column(
              children: ordersItems,
            ),
            textDelivery(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                totalTextWidget(),
                costTextWidget("R\$ ${total.toStringAsFixed(2)}"),
              ],
            ),
            addressDataWidget(order.deliveryAddress),
            SizedBox(height: 10,),
            order.status.isLast() && order.evaluation != null ?
              Column(
                children: [
                  avaliationTextWidget(),
                  StarsWidget(initialStar: order.evaluation.stars, size: 40,),
                ],
              ) : Container(),
            order.evaluation == null ? deliveryCurrentStatus() : Container(),
          ],
        ),
      ),
    );
  }

  Widget deliveryCurrentStatus() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [

          Column(
            children: [
              Text(
                "Previsão de entrega",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              order.status.isFirst() ?
                Text(
                  "Aguarde seu pedido ser confirmado",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                )
                  :
                Text(
                  order.deliveryForecast.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 35,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),


        ],
      ),
    );
  }

  Widget textDelivery() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
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
            "R\$ ${order.deliveryCost.toStringAsFixed(2)}",
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

  Widget orderItem(OrderItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item.amount}x ${item.name}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black45,
                ),
              ),
              Text(
                "R\$ ${(item.getTotal()).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black45,
                ),
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              //fontWeight: FontWeight.bold,
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget body() {
    return Center(
      child: listView(),
    );
  }

  Widget listView() {
    int index = 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              order.status.values.map((e) {
                return statusItemList(e, index++);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleTextWidget(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget dateTextWidget(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget totalTextWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        "Total",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget addressDataWidget(Address address) {
    return Card(
      margin: EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Text(
                "Endereço",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            address.smallTown != null ?
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Text(
                address.smallTown.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ) : Container(),
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
            order.note != null && order.note.isNotEmpty ?
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Text(
                order.note,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ) : Container(),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget costTextWidget(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget avaliationTextWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        "Avaliação",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget statusItemList(Status status, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 3,
                  height: 70,
                  color: Colors.grey[350],
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: this.currentStatusIndex > index ? Colors.grey[350] : this.currentStatusIndex == index ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    color: this.currentStatusIndex > index ? Colors.grey[550] : this.currentStatusIndex == index ? Colors.green : Colors.grey[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                status.date != null ?
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    DateUtil.formatHourMinute(status.date),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}