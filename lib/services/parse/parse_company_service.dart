import 'package:kideliver/utils/log_util.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../../contracts/company/company_contract.dart';
import '../../models/company/company.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseCompanyService extends CompanyContractService {

  BaseParseService service = BaseParseService("Company");

  @override
  Future<Company> create(Company item) async {
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
  Future<Company> read(Company item) {
    return service.read(item).then((response) {
      return response == null ? null : Company.fromMap(response);
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
  Future<Company> update(Company item) {
    return service.update(item).then((response) {
      item.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
      return response == null ? null : Company.fromMap(response);
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
  Future<Company> delete(Company item) {
    return service.delete(item).then((response) {
      return response == null ? null : Company.fromMap(response);
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
  Future<List<Company>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<Company>() : response.map<Company>((item) => Company.fromMap(item)).toList();
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
  Future<List<Company>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<Company>() : response.map<Company>((item) => Company.fromMap(item)).toList();
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
  Future<List<Company>> listFromCity(String id) async {
    var city = QueryBuilder<ParseObject>(ParseObject('City'))
      ..whereEqualTo("objectId", id);

    var address = QueryBuilder<ParseObject>(ParseObject('Address'))
      ..whereMatchesQuery("city", city);

    var company = QueryBuilder<ParseObject>(service.getObject())
      ..whereMatchesQuery("address", address)
      ..whereEqualTo("show", true)
      ..includeObject(["address", "address.city", "deliveryStatus", "pickupStatus"])
      ..orderByDescending("createdAt");

    return await company.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Company>();
        } else {
          List<ParseObject> listObj = value.result;

          return listObj.map<Company>((obj) {
            var companyJson = obj.toJson();
            var addressJson = obj.get("address").toJson();
            var cityJson = obj.get("address").get("city").toJson();
            var delivertStatus = obj.get("deliveryStatus").toJson();
            var pickupStatus = obj.get("pickupStatus").toJson();

            addressJson["city"] = cityJson;
            companyJson["address"] = addressJson;
            companyJson["deliveryStatus"] = delivertStatus;
            companyJson["pickupStatus"] = pickupStatus;

            return Company.fromMap(companyJson);
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
  Future<List<Company>> listFromSmallTown(String id) async {
    var smallTown = QueryBuilder<ParseObject>(ParseObject('SmallTown'))
      ..whereEqualTo("objectId", id);

    var address = QueryBuilder<ParseObject>(ParseObject('Address'))
      ..whereMatchesQuery("smallTown", smallTown);

    var company = QueryBuilder<ParseObject>(service.getObject())
      ..whereMatchesQuery("address", address)
      ..whereEqualTo("show", true)
      ..includeObject(["address", "address.smallTown", "address.smallTown.city", "deliveryStatus", "pickupStatus"])
      ..orderByDescending("createdAt");

    return await company.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Company>();
        } else {
          List<ParseObject> listObj = value.result;

          return listObj.map<Company>((obj) {
            var companyJson = obj.toJson();
            var addressJson = obj.get("address").toJson();
            var smallTownJson = obj.get("address").get("smallTown").toJson();
            var cityJson = obj.get("address").get("smallTown").get("city").toJson();
            var delivertStatus = obj.get("deliveryStatus").toJson();
            var pickupStatus = obj.get("pickupStatus").toJson();

            smallTownJson["city"] = cityJson;
            addressJson["smallTown"] = smallTownJson;
            companyJson["address"] = addressJson;
            companyJson["deliveryStatus"] = delivertStatus;
            companyJson["pickupStatus"] = pickupStatus;

            return Company.fromMap(companyJson);
          }).toList();
        }
      } else {
        throw value.error;
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