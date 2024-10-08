import '../../models/singleton/singleton_user.dart';
import '../../contracts/address/address_contract.dart';
import '../../models/address/address.dart';
import '../../services/firebase/firebase_address_service.dart';

class AddressPresenter implements AddressContractPresenter {
  AddressContractView _view;

  AddressPresenter(this._view);

  AddressContractService service = FirebaseAddressService("address");

  @override
  dispose() {
    service = null;
    _view = null;
  }

  @override
  Future<Address> create(Address item) async {
    return await service.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      print(error);
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Address> read(Address item) async {
    return await service.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Address> update(Address item) async {
    return await service.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Address> delete(Address item) async {
    return await service.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<Address>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<Address>> list() async {
    return await service.list().then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      print(error);
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  listUsersAddress() async {
    return await service.findBy("userId", SingletonUser.instance.id).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

}