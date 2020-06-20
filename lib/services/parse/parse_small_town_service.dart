import '../../contracts/address/small_town_contract.dart';
import '../../models/address/small_town.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseSmallTownService extends SmallTownContractService {

  BaseParseService service = BaseParseService("SmallTown");

  @override
  Future<SmallTown> create(SmallTown item) async {
    return service.create(item).then((response) {
      return response == null ? null : SmallTown.fromMap(response);
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
  Future<SmallTown> read(SmallTown item) {
    return service.read(item).then((response) {
      return response == null ? null : SmallTown.fromMap(response);
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
  Future<SmallTown> update(SmallTown item) {
    return service.update(item).then((response) {
      return response == null ? null : SmallTown.fromMap(response);
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
  Future<SmallTown> delete(SmallTown item) {
    return service.delete(item).then((response) {
      return response == null ? null : SmallTown.fromMap(response);
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
  Future<List<SmallTown>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.map<SmallTown>((item) => SmallTown.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

  @override
  Future<List<SmallTown>> list() {
    return service.list().then((response) {
      return response.map<SmallTown>((item) => SmallTown.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

}