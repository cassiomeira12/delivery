import 'dart:io';
import '../../models/base_user.dart';
import '../../contracts/crud.dart';

abstract class UserContractView {
  onFailure(String error);
  onSuccess(BaseUser user);
}

abstract class UserContractPresenter extends UserContractService {
  dispose();
}

abstract class UserContractService extends Crud<BaseUser> {
  Future<BaseUser> currentUser();
  Future<void> signOut();
  Future<void> changePassword(String email, String password, String newPassword);
  Future<bool> changeName(String name);
  Future<String> changeUserPhoto(File image);
  Future<bool> isEmailVerified();
  Future<void> sendEmailVerification();
}