import 'package:delivery/models/address/address.dart';
import 'package:delivery/utils/log_util.dart';
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

    var company = QueryBuilder<ParseObject>(service.object)
      ..whereMatchesQuery("address", address);

    return await company.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Company>();
        } else {
          List<ParseObject> listObj = value.result;
          List<Map<String, dynamic>> listJson = listObj.map<Map<String, dynamic>>((e) => e.toJson()).toList();
          List<Company> companyList = listJson.map<Company>((item) => Company.fromMap(item)).toList();

          List<String> addressIds = List();
          companyList.forEach((element) {
            addressIds.add(element.address.id);
          });
          var map = await listAddress(addressIds);
          for (var company in companyList) {
            company.address = map[company.address.id];
          }

          return companyList;
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

    var company = QueryBuilder<ParseObject>(service.object)
      ..whereMatchesQuery("address", address)
      ..includeObject(["address"]);

    return await company.query().then((value) async {
      if (value.success) {
        if (value.result == null) {
          return List<Company>();
        } else {
          List<ParseObject> listObj = value.result;
          List<Map<String, dynamic>> listJson = listObj.map<Map<String, dynamic>>((e) => e.toJson()).toList();
          List<Company> companyList = listJson.map<Company>((item) => Company.fromMap(item)).toList();

          List<String> addressIds = List();
          companyList.forEach((element) {
            addressIds.add(element.address.id);
          });
          var map = await listAddress(addressIds);
          for (var company in companyList) {
            company.address = map[company.address.id];
          }

          return companyList;
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
  
  Future<Map<String, Address>> listAddress(List<String> addressIds) async {
    var smallTown = QueryBuilder<ParseObject>(ParseObject('Address'))
      ..whereArrayContainsAll("objectId", addressIds);

    return await smallTown.query().then((value) {
      if (value.success) {
        if (value.result == null) {
          return Map<String, Address>();
        } else {
          List<ParseObject> listObj = value.result;
          List<Map<String, dynamic>> listJson = listObj.map<Map<String, dynamic>>((e) => e.toJson()).toList();
          List<Address> addressList = listJson.map<Address>((item) => Address.fromMap(item)).toList();
          var map = Map<String, Address>();
          addressList.forEach((element) {
            map[element.id] = element;
          });
          return map;
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



}