import 'package:flutter/material.dart';

import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';
import '../../models/singleton/singletons.dart';
import '../../presenters/order/order_presenter.dart';
import '../../strings.dart';
import '../../views/historico/historic_order_page.dart';
import '../../views/historico/historic_widget.dart';
import '../../widgets/empty_list_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../page_router.dart';

class HistoricPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage>
    implements OrderContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;
  OrdersPresenter presenter;

  //List<Order> ordersList;

  @override
  void initState() {
    super.initState();
    presenter = OrdersPresenter(this);
    presenter.listUserOrders();
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
      PageRouter.push(
          context,
          HistoricOrderPage(
            order: newOrder,
          ));
      Singletons.order().clear();
    }
  }

  @override
  listSuccess(List<Order> list) {
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (Singletons.orders().isNotEmpty) {
      list.forEach((item) {
        var temp;
        for (var element in Singletons.orders()) {
          if (item.id == element.id) {
            temp = element;
            break;
          }
        }
        if (temp == null) {
          setState(() {
            Singletons.orders().insert(0, item);
          });
        } else {
          setState(() {
            temp.updateData(item);
          });
        }
      });
    } else {
      setState(() {
        Singletons.orders().addAll(list);
      });
    }
    setState(() => _loading = false);
  }

  @override
  onFailure(String error) {
    setState(() {
      _loading = false;
      Singletons.orders().clear();
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(Order result) {
    setState(() {
      _loading = false;
      Singletons.orders().insert(0, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          TAB3,
          style: TextStyle(color: Colors.white),
        ),
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
            Singletons.orders().clear();
            _loading = true;
          });
          return presenter.findBy("user", Singletons.user().toPointer());
        },
        child: Center(
          child: _loading
              ? LoadingWidget()
              : Stack(
                  children: [
                    listOrders(),
                    Singletons.orders().isEmpty
                        ? EmptyListWidget(
                            message: "Nenhum pedido foi encontrado",
                          )
                        : Container(),
                  ],
                ),
        ));
  }

  Widget listOrders() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildListDelegate(Singletons.orders().map<Widget>((item) {
            return GestureDetector(
              child: HistoricWidget(item: item),
              onTap: () async {
                var result = await PageRouter.push(
                    context, HistoricOrderPage(order: item));
                setState(() => item = result);
              },
            );
          }).toList()),
        ),
      ],
    );
  }
}
