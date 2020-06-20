import '../../contracts/address/states_contract.dart';
import '../../models/address/states.dart';
import '../../services/parse/parse_states_service.dart';

class StatesPresenter implements StatesContractPresenter {
  StatesContractView _view;

  StatesPresenter(this._view);

  StatesContractService service = ParseStatesService();

  @override
  dispose() {
    service = null;
    _view = null;
  }

  @override
  Future<States> create(States item) async {
    return await service.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<States> read(States item) async {
    return await service.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<States> update(States item) async {
    return await service.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<States> delete(States item) async {
    return await service.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<States>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<States>> list() async {
    return await service.list().then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error);
      return null;
    });
  }

}