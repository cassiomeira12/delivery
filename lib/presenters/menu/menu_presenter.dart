import '../../services/parse/parse_menu_service.dart';
import '../../models/menu/menu.dart';
import '../../services/firebase/firebase_menu_service.dart';
import '../../contracts/menu/menu_contract.dart';

class MenuPresenter implements MenuContractPresenter {
  final MenuContractView _view;

  MenuPresenter(this._view);

  //MenuContractService service = FirebaseMenuService("menus");
  MenuContractService service = ParseMenuService();

  @override
  dispose() {
    service = null;
  }

  @override
  Future<Menu> create(Menu item) async {
    return await service.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Menu> read(Menu item) async {
    return await service.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Menu> update(Menu item) async {
    return await service.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Menu> delete(Menu item) async {
    return await service.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Menu>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      if (_view != null) _view.listSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Menu>> list() async {
    return await service.list().then((value) {
      _view.listSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

}