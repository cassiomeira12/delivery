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
      return response.map<Company>((item) => Company.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

  @override
  Future<List<Company>> list() {
    return service.list().then((response) {
      response.forEach((element) {
        print(element);
        Company.fromMap(element);
      });
      return response.map<Company>((item) => Company.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

}