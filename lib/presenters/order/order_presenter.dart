import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:async';
import '../../models/singleton/singletons.dart';
import '../../utils/log_util.dart';
import '../../services/parse/parse_order_service.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';

class OrdersPresenter implements OrderContractPresenter {
  final OrderContractView _view;

  OrdersPresenter(this._view);

  //OrderContractService service = FirebaseOrderService("orders");
  OrderContractService service = ParseOrderService();

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
    service = null;
    if (liveQuery != null) liveQuery.client.unSubscribe(subscription);
  }

  @override
  Future<Order> create(Order item) async {
    return await service.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Order> read(Order item) async {
    return await service.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Order> update(Order item) async {
    return await service.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Order> delete(Order item) async {
    return await service.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Order>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Order>> list() async {
    return await service.list().then((value) {
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

    QueryBuilder query = QueryBuilder(item)
      ..whereEqualTo("objectId", item.id);

    subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.update, (value) {
      if (_view != null) _view.onSuccess(Order.fromMap(value.toJson()));
    });
  }

  @override
  listUserOrders() async {
    liveQuery = LiveQuery();

    QueryBuilder query = QueryBuilder(ParseObject("Order"))
      ..whereEqualTo("user", Singletons.user().toPointer());

    subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.update, (value) {
      Log.d(value);
      if (_view != null) _view.listSuccess([Order.fromMap(value.toJson())]);
    });
  }
}