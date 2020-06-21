import '../../services/parse/parse_small_town_service.dart';
import '../../contracts/address/small_town_contract.dart';
import '../../models/address/small_town.dart';
import '../../services/firebase/firebase_small_town_service.dart';

class SmallTownPresenter implements SmallTownContractPresenter {
  SmallTownContractView _view;

  SmallTownPresenter(this._view);

  //SmallTownContractService service = FirebaseSmallTownService("smallTowns");
  SmallTownContractService service = ParseSmallTownService();

  @override
  dispose() {
    service = null;
    _view = null;
  }

  @override
  Future<SmallTown> create(SmallTown item) async {
    return await service.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<SmallTown> read(SmallTown item) async {
    return await service.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<SmallTown> update(SmallTown item) async {
    return await service.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<SmallTown> delete(SmallTown item) async {
    return await service.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<SmallTown>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<SmallTown>> list() async {
    return await service.list().then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

}