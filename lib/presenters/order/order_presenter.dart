import 'dart:async';

import 'package:kideliver/contracts/order/cupon_contract.dart';
import 'package:kideliver/models/order/cupon.dart';
import 'package:kideliver/services/parse/parse_cupon_service.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';
import '../../models/singleton/singletons.dart';
import '../../services/parse/parse_order_service.dart';

class OrdersPresenter implements OrderContractPresenter {
  final OrderContractView _view;

  OrdersPresenter(this._view);

  //OrderContractService service = FirebaseOrderService("orders");
  OrderContractService orderService = ParseOrderService();
  CuponContractService cuponService = ParseCuponService();

  LiveQuery liveQuery;
  Subscription subscription;

  void pause() {
    if (liveQuery != null) liveQuery.client.disconnect();
  }

  void resume() {
    if (liveQuery != null) liveQuery.client.reconnect();
  }

  @override
  dispose() {
    orderService = null;
    if (liveQuery != null) liveQuery.client.unSubscribe(subscription);
  }

  @override
  Future<Order> create(Order item) async {
    return await orderService.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Order> read(Order item) async {
    return await orderService.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Order> update(Order item) async {
    return await orderService.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Order> delete(Order item) async {
    return await orderService.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Order>> findBy(String field, value) async {
    return await orderService.findBy(field, value).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Order>> list() async {
    return await orderService.list().then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  readSnapshot(Order item) async {
    liveQuery = LiveQuery();

    QueryBuilder query = QueryBuilder(item)..whereEqualTo("objectId", item.id);

    subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.update, (value) async {
      var order = Order.fromMap(value.toJson());
      var cuponJson = value["cupon"];
      if (cuponJson != null) {
        var cupon =
            await cuponService.read(Cupon()..id = cuponJson["objectId"]);
        order.cupon = cupon;
      }
      _view != null ? _view.onSuccess(order) : null;
    });
  }

  @override
  listUserOrders() async {
    liveQuery = LiveQuery();

    QueryBuilder query = QueryBuilder(ParseObject("Order"))
      ..whereEqualTo("user", Singletons.user().toPointer())
      ..orderByDescending("createdAt");

    subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.update, (value) async {
      var order = Order.fromMap(value.toJson());
      var cuponJson = value["cupon"];
      if (cuponJson != null) {
        var cupon =
            await cuponService.read(Cupon()..id = cuponJson["objectId"]);
        order.cupon = cupon;
      }
      if (_view != null) _view.listSuccess([order]);
    });
  }
}
