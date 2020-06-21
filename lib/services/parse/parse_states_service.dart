import '../../contracts/address/states_contract.dart';
import '../../models/address/states.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseStatesService extends StatesContractService {

  BaseParseService service = BaseParseService("State");

  @override
  Future<States> create(States item) async {
    return service.create(item).then((response) {
      return response == null ? null : States.fromMap(response);
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
  Future<States> read(States item) {
    return service.read(item).then((response) {
      return response == null ? null : States.fromMap(response);
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
  Future<States> update(States item) {
    return service.update(item).then((response) {
      return response == null ? null : States.fromMap(response);
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
  Future<States> delete(States item) {
    return service.delete(item).then((response) {
      return response == null ? null : States.fromMap(response);
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
  Future<List<States>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<States>() : response.map<States>((item) => States.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

  @override
  Future<List<States>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<States>() : response.map<States>((item) => States.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

}