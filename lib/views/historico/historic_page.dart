import '../../models/singleton/singletons.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../widgets/loading_widget.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';
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

  OrdersPresenter presenter;

  List<Order> ordersList;

  @override
  void initState() {
    super.initState();
    presenter = OrdersPresenter(this);
    presenter.listUserOrders();
    ordersList = Singletons.orders();
    verifyNewOrder();
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  void verifyNewOrder() async {
    if (Singletons.order().id != null) {
      Order newOrder = Order();
      newOrder.updateData(Singletons.order());
      await Future.delayed(Duration(seconds: 1));
      PageRouter.push(context, HistoricOrderPage(order: newOrder,));
      Singletons.order().clear();
    }
  }

  @override
  listSuccess(List<Order> list) {
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (ordersList != null && ordersList.isNotEmpty) {
      list.forEach((item) {
        var temp;
        for (var element in Singletons.orders()) {
          if (item.id == element.id) {
            temp = element;
            return;
          }
        }
        if (temp == null) {
          setState(() {
            ordersList.insert(0, item);
          });
        } else {
          setState(() {
            temp.updateData(item);
          });
        }
      });
    } else {
      setState(() {
        ordersList = list;
      });
      Singletons.orders().addAll(list);
    }
  }

  @override
  onFailure(String error)  {
    setState(() {
      ordersList = List();
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(Order result) {
    Singletons.orders().add(result);
    setState(() {
      ordersList.insert(0, result);
    });
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
      onRefresh: () {
        setState(() {
          ordersList = null;
        });
        Singletons.orders().clear();
        return presenter.findBy("user", Singletons.user().toPointer());
      },
      child: Center(
        child: ordersList == null ?
          LoadingWidget()
            :
          Stack(
            children: [
              listOrders(),
              ordersList.isEmpty ?
                EmptyListWidget(
                  message: "Nenhum pedido foi encontrado",
//                  onPressed: () async {
//                    setState(() {
//                      ordersList = null;
//                    });
//                    Singletons.orders().clear();
//                    presenter.findBy("user", Singletons.user().toPointer());
//                  },
                ) : Container(),
            ],
          ),
      )
    );
  }

  Widget listOrders() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
              ordersList.map<Widget>((item) {
                return GestureDetector(
                  child: HistoricWidget(item: item),
                  onTap: () async {
                    await PageRouter.push(context, HistoricOrderPage(order: item));
                  },
                );
              }).toList()
          ),
        ),
      ],
    );
  }

}