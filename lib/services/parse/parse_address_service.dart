import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../../models/base_user.dart';
import '../../contracts/address/address_contract.dart';
import '../../models/address/address.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseAddressService extends AddressContractService {

  BaseParseService service = BaseParseService("Address");

  @override
  Future<Address> create(Address item) {
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
  Future<Address> read(Address item) {
    return service.read(item).then((response) {
      return response == null ? null : Address.fromMap(response);
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
  Future<Address> update(Address item) {
    return service.update(item).then((response) {
      item.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
      return response == null ? null : Address.fromMap(response);
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
  Future<Address> delete(Address item) {
    return service.delete(item).then((response) {
      return response == null ? null : Address.fromMap(response);
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
  Future<List<Address>> findBy(String field, value) async {
    var query = QueryBuilder<ParseObject>(service.getObject())
      ..whereEqualTo(field, value)
      ..includeObject(["city", "smallTown", "smallTown.city"]);

    return await query.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Address>();
        } else {
          List<ParseObject> listObj = value.result;

          return listObj.map<Address>((obj) {
            var root = obj.toJson();
            var smallTownJson = obj.get("smallTown");
            var cityJson = obj.get("city");

            if (smallTownJson != null) {
              var json = smallTownJson.toJson();
              json["city"] = obj.get("smallTown").get("city").toJson();
              root["smallTown"] = json;
            }
            if (cityJson != null) {
              root["city"] = cityJson.toJson();
            }

            return Address.fromMap(root);
          }).toList();
        }
      } else {
        switch (value.error.code) {
          case -1:
            throw Exception(ERROR_NETWORK);
            break;
          default:
            throw Exception(value.error.message);
        }
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
  Future<List<Address>> list() async {
    return await service.list().then((response) {
      return response.isEmpty ? List<Address>() : response.map<Address>((item) => Address.fromMap(item)).toList();
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
  listUserAddress(BaseUser user, Address address) async {
    var query;

    if (address.city == null) {
      query = QueryBuilder<ParseObject>(service.getObject())
        ..whereEqualTo("user", user.toPointer())
        ..whereEqualTo("smallTown", address.smallTown.toPointer())
        ..includeObject(["city", "smallTown", "smallTown.city"]);
    } else {
      query = QueryBuilder<ParseObject>(service.getObject())
        ..whereEqualTo("user", user.toPointer())
        ..whereEqualTo("city", address.city.toPointer())
        ..includeObject(["city", "smallTown", "smallTown.city"]);
    }

    return await query.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Address>();
        } else {
          List<ParseObject> listObj = value.result;

          return listObj.map<Address>((obj) {
            var root = obj.toJson();
            var smallTownJson = obj.get("smallTown");
            var cityJson = obj.get("city");

            if (smallTownJson != null) {
              var json = smallTownJson.toJson();
              json["city"] = obj.get("smallTown").get("city").toJson();
              root["smallTown"] = json;
            }
            if (cityJson != null) {
              root["city"] = cityJson.toJson();
            }

            return Address.fromMap(root);
          }).toList();
        }
      } else {
        switch (value.error.code) {
          case -1:
            throw Exception(ERROR_NETWORK);
            break;
          default:
            throw Exception(value.error.message);
        }
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

}