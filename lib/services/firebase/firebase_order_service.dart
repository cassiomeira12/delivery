import 'package:cloud_firestore/cloud_firestore.dart';
import '../../contracts/order/order_contract.dart';
import '../../utils/log_util.dart';
import '../../models/order/order.dart';

import 'base_firebase_service.dart';

class FirebaseOrderService implements OrderContractService {
  CollectionReference _collection;
  BaseFirebaseService _firebaseCrud;

  FirebaseOrderService(String path) {
    _firebaseCrud = BaseFirebaseService(path);
    _collection = _firebaseCrud.collection;
  }

  @override
  Future<Order> create(Order item) async {
    return _firebaseCrud.create(item).then((response) {
      return Order.fromMap(response);
    });
  }

  @override
  Future<Order> read(Order item) {
    return _firebaseCrud.read(item).then((response) {
      return Order.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<Order> update(Order item) {
    return _firebaseCrud.update(item).then((response) {
      return Order.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<Order> delete(Order item) {
    return _firebaseCrud.delete(item).then((response) {
      return Order.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<List<Order>> findBy(String field, value) async {
    return _firebaseCrud.findBy(field, value).then((response) {
      return response.map<Order>((item) => Order.fromMap(item)).toList();
    });
  }

  @override
  Future<List<Order>> list() {
    return _firebaseCrud.list().then((response) {
      return response.map<Order>((item) => Order.fromMap(item)).toList();
    });
  }

}