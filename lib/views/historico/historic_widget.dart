import 'package:flutter/material.dart';

import '../../models/order/order.dart';
import '../../utils/date_util.dart';
import '../../widgets/stars_widget.dart';

class HistoricWidget extends StatefulWidget {
  final dynamic item;

  HistoricWidget({this.item});

  @override
  _HistoricWidgetState createState() => _HistoricWidgetState();
}

class _HistoricWidgetState extends State<HistoricWidget> {
  Order order;
  double total = 0;

  @override
  void initState() {
    super.initState();
    order = widget.item as Order;
    total = order.deliveryCost;
    order.items.forEach((element) {
      total += element.getTotal();
    });
    if (order.cupon != null) {
      total += -order.cupon.calcPercentDiscount(total) -
          order.cupon.getMoneyDiscount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
      elevation: 5,
      shadowColor: order.canceled
          ? Colors.red
          : order.status.isLast()
              ? order.evaluation == null ? Colors.amber : Colors.white
              : order.status.isFirst() ? Colors.green : Colors.lightBlue,
      color: order.canceled
          ? Colors.white
          : order.status.isLast()
              ? order.evaluation == null ? Colors.amber[100] : Colors.white
              : order.status.isFirst()
                  ? Colors.green[50]
                  : Colors.lightBlue[50],
      borderOnForeground: true,
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                order.evaluation == null
                    ? Flexible(
                        flex: 1,
                        child: Text(
                          order.canceled
                              ? "Esse pedido foi cancelado"
                              : order.status.current.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      )
                    : StarsWidget(
                        initialStar: order.evaluation.stars,
                        size: 30,
                      ),
                order.canceled
                    ? Container()
                    : costTextWidget("R\$ ${total.toStringAsFixed(2)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget titleTextWidget(String text) {
    return Flexible(
      child: Text(
        text,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
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

  Widget costTextWidget(String text) {
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
}
