import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../../contracts/order/order_contract.dart';
import '../../models/order/order.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseOrderService extends OrderContractService {
  BaseParseService service = BaseParseService("Order");

  @override
  Future<Order> create(Order item) async {
    return service.create(item).then((response) {
      var temp = Order();
      temp.updateData(item);
      temp.id = response["objectId"];
      temp.objectId = response["objectId"];
      temp.createdAt = DateTime.parse(response["createdAt"]).toLocal();
      return response == null ? null : temp;
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
      var temp = Order();
      temp.updateData(item);
      temp.id = response["objectId"];
      temp.objectId = response["objectId"];
      item.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
      return response == null ? null : temp;
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
    var includes = ["cupon"];

    var query = QueryBuilder<ParseObject>(service.getObject())
      ..whereEqualTo(field, value)
      ..includeObject(includes)
      ..orderByDescending("createdAt");

    return await query.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Order>();
        } else {
          List<ParseObject> listObj = value.result;

          return listObj.map<Order>((obj) {
            var objectJson = obj.toJson();

            for (var include in includes) {
              try {
                var json = obj.get(include).toJson();
                objectJson[include] = json;
              } catch (error) {
                print("sem $include");
              }
            }

            return Order.fromMap(objectJson);
          }).toList();
        }
      } else {
        return throw value.error;
      }
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
      return response.isEmpty
          ? List<Order>()
          : response.map<Order>((item) => Order.fromMap(item)).toList();
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
