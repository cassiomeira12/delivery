import '../../contracts/address/city_contract.dart';
import '../../models/address/city.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseCityService extends CityContractService {

  BaseParseService service = BaseParseService("City");

  @override
  Future<City> create(City item) async {
    return service.create(item).then((response) {
      item.id = response["objectId"];
      item.objectId = response["objectId"];
      item.createdAt = response["createdAt"];
      item.updatedAt = response["updatedAt"];
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
  Future<City> read(City item) {
    return service.read(item).then((response) {
      return response == null ? null : City.fromMap(response);
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
  Future<City> update(City item) {
    return service.update(item).then((response) {
      return response == null ? null : City.fromMap(response);
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
  Future<City> delete(City item) {
    return service.delete(item).then((response) {
      return response == null ? null : City.fromMap(response);
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
  Future<List<City>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<City>() : response.map<City>((item) => City.fromMap(item)).toList();
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
  Future<List<City>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<City>() : response.map<City>((item) => City.fromMap(item)).toList();
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