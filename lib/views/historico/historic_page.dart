import '../../widgets/loading_widget.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';
import '../../models/singleton/order_singleton.dart';
import '../../presenters/order/order_presenter.dart';
import '../../views/historico/historic_order_page.dart';
import '../../views/historico/historic_widget.dart';
import '../../widgets/empty_list_widget.dart';
import '../../strings.dart';
import 'package:flutter/material.dart';
import '../page_router.dart';

class HistoricPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> implements OrderContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderContractPresenter presenter;

  List<Order> ordersList;

  @override
  void initState() {
    super.initState();
    verifyNewOrder();
    presenter = OrdersPresenter(this);
    presenter.listUserOrders();
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  void verifyNewOrder() async {
    if (OrderSingleton.instance.id != null) {
      Order newOrder = Order.fromMap(OrderSingleton.instance.toMap());
      await Future.delayed(Duration(seconds: 1));
      PageRouter.push(context, HistoricOrderPage(item: newOrder,));
      OrderSingleton.instance.clear();
    }
  }

  @override
  listSuccess(List<Order> list) {
    setState(() {
      ordersList = list;
    });
  }

  @override
  onFailure(String error)  {
    print(error);
  }

  @override
  onSuccess(Order result) {
    print("success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(TAB3, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: body(),
    );
  }

  Widget body() {
    final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => presenter.listUserOrders(),
      child: Center(
        child: ordersList == null ?
        LoadingWidget()
            :
        ordersList.isEmpty ?
        EmptyListWidget(
          message: "Você ainda não fez pedidos",
          //assetsImage: "assets/notification.png",
        )
            :
        CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                  ordersList.map<Widget>((item) {
                    return HistoricWidget(item: item,);
                  }).toList()
              ),
            ),
          ],
        ),
      )
    );
  }

}