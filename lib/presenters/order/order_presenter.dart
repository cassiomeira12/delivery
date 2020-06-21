import 'dart:async';
import '../../services/parse/parse_order_service.dart';
import '../../models/singleton/singleton_user.dart';
import '../../services/firebase/firebase_order_service.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';

class OrdersPresenter implements OrderContractPresenter {
  final OrderContractView _view;

  OrdersPresenter(this._view);

  //OrderContractService service = FirebaseOrderService("orders");
  OrderContractService service = ParseOrderService();

  StreamSubscription _streamSubscription;

  void pause() {
    if (_streamSubscription != null) _streamSubscription.pause();
  }

  void resume() {
    if (_streamSubscription != null) _streamSubscription.resume();
  }

  @override
  dispose() {
    service = null;
    if (_streamSubscription != null) _streamSubscription.cancel();
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
    _streamSubscription = service.readSnapshot(item).listen((event) {
      if (_view != null) _view.onSuccess(Order.fromMap(event.data));
    });
  }

  @override
  listUserOrders() async {
    _streamSubscription = service.listUserOrders(SingletonUser.instance.id).listen((event) {
      if (_view != null) _view.listSuccess(
        event.documents.map<Order>((e) {
          return Order.fromMap(e.data);
        }).toList()
      );
    });
  }



}