import '../../models/order/cupon.dart';
import '../../contracts/order/cupon_contract.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseCuponService extends CuponContractService {

  BaseParseService service = BaseParseService("Cupon");

  @override
  Future<Cupon> create(Cupon item) async {
    return service.create(item).then((response) {
      Cupon temp = Cupon();
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
  Future<Cupon> read(Cupon item) {
    return service.read(item).then((response) {
      return response == null ? null : Cupon.fromMap(response);
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
  Future<Cupon> update(Cupon item) {
    return service.update(item).then((response) {
      Cupon temp = Cupon();
      temp.updateData(item);
      temp.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
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
  Future<Cupon> delete(Cupon item) {
    return service.delete(item).then((response) {
      return response == null ? null : Cupon.fromMap(response);
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
  Future<List<Cupon>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<Cupon>() : response.map<Cupon>((item) => Cupon.fromMap(item)).toList();
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
  Future<List<Cupon>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<Cupon>() : response.map<Cupon>((item) => Cupon.fromMap(item)).toList();
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