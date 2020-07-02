import '../../utils/log_util.dart';
import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseOrderService extends OrderContractService {

  BaseParseService service = BaseParseService("Order");

  @override
  Future<Order> create(Order item) async {
    return service.create(item).then((response) {
      item.id = response["objectId"];
      item.objectId = response["objectId"];
      item.createdAt = DateTime.parse(response["createdAt"]).toLocal();
      return response == null ? null : item;
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<Order> read(Order item) {
    return service.read(item).then((response) {
      return response == null ? null : Order.fromMap(response);
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<Order> update(Order item) {
    return service.update(item).then((response) {
      item.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
      return response == null ? null : Order.fromMap(response);
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<Order> delete(Order item) {
    return service.delete(item).then((response) {
      return response == null ? null : Order.fromMap(response);
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<List<Order>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<Order>() : response.map<Order>((item) => Order.fromMap(item)).toList();
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<List<Order>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<Order>() : response.map<Order>((item) => Order.fromMap(item)).toList();
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

}