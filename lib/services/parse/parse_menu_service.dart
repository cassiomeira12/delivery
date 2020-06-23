import '../../contracts/menu/menu_contract.dart';
import '../../models/menu/menu.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseMenuService extends MenuContractService {

  BaseParseService service = BaseParseService("Menu");

  @override
  Future<Menu> create(Menu item) async {
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
  Future<Menu> read(Menu item) {
    return service.read(item).then((response) {
      return response == null ? null : Menu.fromMap(response);
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
  Future<Menu> update(Menu item) {
    return service.update(item).then((response) {
      item.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
      return response == null ? null : Menu.fromMap(response);
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
  Future<Menu> delete(Menu item) {
    return service.delete(item).then((response) {
      return response == null ? null : Menu.fromMap(response);
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
  Future<List<Menu>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<Menu>() : response.map<Menu>((item) => Menu.fromMap(item)).toList();
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
  Future<List<Menu>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<Menu>() : response.map<Menu>((item) => Menu.fromMap(item)).toList();
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