import '../../models/singleton/singleton_user.dart';
import '../../contracts/address/address_contract.dart';
import '../../models/address/address.dart';
import '../../services/firebase/firebase_address_service.dart';

class AddressPresenter implements AddressContractPresenter {
  final AddressContractView _view;

  AddressPresenter(this._view);

  AddressContractService service = FirebaseAddressService("address");

  @override
  dispose() {
    service = null;
  }

  @override
  Future<Address> create(Address item) async {
    return await service.create(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      print(error);
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Address> read(Address item) async {
    return await service.read(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Address> update(Address item) async {
    return await service.update(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Address> delete(Address item) async {
    return await service.create(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<Address>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      _view.listSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<Address>> list() async {
    return await service.list().then((value) {
      _view.listSuccess(value);
      return value;
    }).catchError((error) {
      print(error);
      _view.onFailure(error);
      return null;
    });
  }

  @override
  listUsersAddress() async {
    return await service.findBy("userId", SingletonUser.instance.id).then((value) {
      _view.listSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

}