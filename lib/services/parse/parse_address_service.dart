import '../../contracts/address/address_contract.dart';
import '../../models/address/address.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseAddressService extends AddressContractService {

  BaseParseService service = BaseParseService("Address");

  @override
  Future<Address> create(Address item) async {
    return service.create(item).then((response) {
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
    return service.findBy(field, value).then((response) {
      return response.map<Address>((item) => Address.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

  @override
  Future<List<Address>> list() {
    return service.list().then((response) {
      return response.map<Address>((item) => Address.fromMap(item)).toList();
    }).catchError((error) {
      return throw Exception(error.message);
    });
  }

}