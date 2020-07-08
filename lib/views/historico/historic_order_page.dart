import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kideliver/widgets/scaffold_snackbar.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../strings.dart';
import '../../views/historico/evalutation_dialog.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/address/address.dart';
import '../../models/order/order.dart';
import '../../models/order/order_item.dart';
import '../../models/order/order_status.dart';
import '../../presenters/order/order_presenter.dart';
import '../../utils/date_util.dart';
import '../../widgets/stars_widget.dart';

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
    checkEvalutationOrder();
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
    order = result;
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
    if (order.status.isLast() && order.evaluation == null && !order.canceled) {
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
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp,),
            onPressed: () async {
              var whatsAppLink = order.companyPhoneNumber.whatsAppLink();
              if (await canLaunch(whatsAppLink)) {
                await launch(whatsAppLink);
              } else {
                ScaffoldSnackBar.failure(context, _scaffoldKey, SOME_ERROR);
              }
            },
          ),
//          PopupMenuButton(
//            itemBuilder: (BuildContext context) {
//              return ["WhatsApp"].map((String choice) {
//                return PopupMenuItem(
//                  value: choice,
//                  child: Text(choice),
//                );
//              }).toList();
//            },
//            onSelected: (value) async {
//              switch (value) {
//                case "WhatsApp":
//                  var whatsAppLink = order.companyPhoneNumber.whatsAppLink();
//                  if (await canLaunch(whatsAppLink)) {
//                    await launch(whatsAppLink);
//                  } else {
//                    ScaffoldSnackBar.failure(context, _scaffoldKey, SOME_ERROR);
//                  }
//                  break;
//              }
//            },
//          ),
        ],
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
      body: timeLine(),
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
                Flexible(
                  flex: 1,
                  child: titleTextWidget(order.companyName),
                ),
                dateTextWidget(DateUtil.formatDateMouthHour(order.createdAt)),
              ],
            ),
            SizedBox(height: 5,),
            Column(children: ordersItems,),
            textDelivery(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                totalTextWidget(),
                costTextWidget("R\$ ${total.toStringAsFixed(2)}"),
              ],
            ),
            textPaymentType(),
            addressDataWidget(order.deliveryAddress),
            SizedBox(height: 10,),
            order.status.isLast() && order.evaluation != null ?
              Column(
                children: [
                  avaliationTextWidget(),
                  StarsWidget(initialStar: order.evaluation.stars, size: 40,),
                  avaliationComenteTextWidget(),
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
          order.canceled ?
            orderCanceled()
            :
            Column(
            children: [
              AutoSizeText(
                "Previsão de entrega",
                maxLines: 1,
                textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                )
                  :
                Text(
                  order.deliveryForecast == null ? "" : order.deliveryForecast.toString(),
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
          Flexible(
            flex: 1,
            child: AutoSizeText(
              "Taxa de entrega",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black45,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "R\$ ${order.deliveryCost.toStringAsFixed(2)}",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget textPaymentType() {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: AutoSizeText(
              order.typePayment.getType(),
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            order.changeMoney == null ? "Sem troco" : order.changeMoney,
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
              Flexible(
                flex: 1,
                child: AutoSizeText(
                  "${item.amount}x ${item.name}",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
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
                fontWeight: FontWeight.bold,
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

  Widget orderCanceled() {
    return Text(
      "Esse pedido foi cancelado",
      style: TextStyle(
        fontSize: 22,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget timeLine() {
    int index = 0;
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            order.status.values.map((e) {
              return timelineItem(e, index++);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget avaliationComenteTextWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        order.evaluation.comment,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget timelineItem(Status status, int index) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: 0.1,
      isFirst: index == 0,
      isLast: index == (order.status.values.length-1),
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: currentStatusIndex > index ? Colors.grey : currentStatusIndex == index ? Colors.green : Colors.grey[300],
        padding: EdgeInsets.all(6),
      ),
      rightChild: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                DateUtil.formatDateMouthHour(status.date),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
      topLineStyle: const LineStyle(
        color: Color(0xFFDADADA),
      ),
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
      elevation: 5,
      margin: EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: order.delivery ? FaIcon(FontAwesomeIcons.motorcycle,) : FaIcon(FontAwesomeIcons.running,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 10),
                      child: Text(
                        order.delivery ? "Endereço de entrega" : "Endereço de retirada",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 10),
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
                      padding: EdgeInsets.only(top: 5, right: 10),
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
                      padding: EdgeInsets.only(top: 5, right: 10),
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
                      padding: EdgeInsets.only(top: 5, right: 10),
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
              ],
            ),
            order.deliveryAddress.location != null ?
              GestureDetector(
                child: Container(
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
                ),
                onTap: () async {
                  var address = order.deliveryAddress;
                  if (address != null) {
                    MapsLauncher.launchCoordinates(address.location.latitude, address.location.longitude);
                  } else {
                    ScaffoldSnackBar.failure(context, _scaffoldKey, SOME_ERROR);
                  }
                },
              ) : Container(),
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
                    color: currentStatusIndex > index ? Colors.grey[350] : currentStatusIndex == index ? Colors.green : Colors.grey[300],
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