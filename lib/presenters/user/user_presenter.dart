import 'dart:io';
import '../../models/singleton/singletons.dart';
import '../../services/parse/parse_user_service.dart';
import '../../contracts/user/user_contract.dart';
import '../../models/base_user.dart';
import '../../contracts/crud.dart';
import '../../services/firebase/firebase_user_service.dart';
import '../../strings.dart';

class UserPresenter implements UserContractPresenter, Crud<BaseUser> {
  final UserContractView _view;
  UserPresenter(this._view);

  //UserContractService service = FirebaseUserService("users");
  UserContractService service = ParseUserService();

  @override
  dispose() {
    service = null;
  }

  @override
  Future<BaseUser> create(BaseUser item) async {
    return await service.create(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<BaseUser> read(BaseUser item) async {
    return await service.read(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<BaseUser> update(BaseUser item) async {
    return await service.update(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<BaseUser> delete(BaseUser item) async {
    return await service.delete(item).then((value) {
      if (_view != null) _view.onSuccess(value);
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<BaseUser>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      return value;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<BaseUser>> list() { }

  @override
  Future<bool> changeName(String name) async {
    return await service.changeName(name).then((value) {
      if (value) {
        if (_view != null) _view.onSuccess(Singletons.user());
      } else {
        if (_view != null) _view.onFailure(CHANGE_NAME_FAILURE);
      }
      return value;
    });
  }

  @override
  Future<String> changeUserPhoto(File image) async {
    return await service.changeUserPhoto(image).then((URL) {
      Singletons.user().avatarURL = URL;
      if (_view != null) _view.onSuccess(Singletons.user());
      return URL;
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<String> changePassword(String email, String password, String newPassword) async {
    await service.changePassword(email, password, newPassword).then((value) {
      if (_view != null) _view.onSuccess(null);
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
    });
  }

  @override
  Future<BaseUser> currentUser() async {
    BaseUser user = await service.currentUser();
    if (_view != null) {
      user == null ? _view.onFailure("") : _view.onSuccess(user);
    }
    return user;
  }

  @override
  Future<void> signOut() {
    return service.signOut();
  }

  @override
  Future<bool> isEmailVerified() {
    return service.isEmailVerified();
  }

  @override
  Future<void> sendEmailVerification() async {
    await service.sendEmailVerification().then((value) {
      if (_view != null) _view.onSuccess(null);
    }).catchError((error) {
      if (_view != null) _view.onFailure(ERROR_ENVIAR_EMAIL);
    });
  }

}