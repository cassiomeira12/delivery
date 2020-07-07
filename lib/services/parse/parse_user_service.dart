import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'base_parse_service.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import '../../models/singleton/singletons.dart';
import '../../contracts/user/user_contract.dart';
import '../../models/base_user.dart';
import '../../strings.dart';
import '../../utils/log_util.dart';
import '../../utils/preferences_util.dart';

class ParseUserService implements UserContractService {
  BaseParseService _service;

  ParseUserService() {
    _service = BaseParseService("_User");
  }

  @override
  Future<BaseUser> create(BaseUser item) async {
    return _service.create(item).then((response) {
      item.id = response["objectId"];
      item.objectId = response["objectId"];
      item.createdAt = DateTime.parse(response["createdAt"]).toLocal();
      return response == null ? null : item;
    }).catchError((error) {
      Log.e(error);
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        case 202:
          throw Exception(ERROR_ALREADY_EXISTS);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<BaseUser> read(BaseUser item) {
    return _service.read(item).then((response) {
      return response == null ? null : BaseUser.fromMap(response);
    }).catchError((error) {
      Log.e(error);
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
  Future<BaseUser> update(BaseUser item) async {
    var temp = BaseUser.fromMap(item.toMap());
    temp.username = null;
    temp.email = null;
    temp.password = null;
    return _service.update(temp).then((response) {
      item.updatedAt = DateTime.parse(response["updatedAt"]).toLocal();
      return response == null ? null : item;
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
  Future<BaseUser> delete(BaseUser item) {
    return _service.delete(item).then((response) {
      return response == null ? null : item;
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
  Future<List<BaseUser>> findBy(String field, value) async {
    return _service.findBy(field, value).then((response) {
      return response.isEmpty ? List<BaseUser>() : response.map<BaseUser>((item) => BaseUser.fromMap(item)).toList();
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
  Future<List<BaseUser>> list() {
    return _service.list().then((response) {
      return response.isEmpty ? List<BaseUser>() : response.map<BaseUser>((item) => BaseUser.fromMap(item)).toList();
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

  Future<BaseUser> findUserByEmail(String email) async {
    return await findBy("email", email).then((response) {
      if (response.length == 1) {
        return response.first;
      } else if (response.length == 0) {
        Log.e("Usuário não encontrado");
        return null;
      } else {
        Log.e("Mais de 1 usuário com mesmo email");
        return null;
      }
    });
//    }).catchError((error) {
//      switch (error.code) {
//        case -1:
//          throw Exception(ERROR_NETWORK);
//          break;
//        default:
//          throw Exception(error.message);
//      }
//    });
  }

  @override
  Future<BaseUser> createAccount(BaseUser user) async {
    return await create(user);
  }

  @override
  Future<void> changePassword(String email, String password, String newPassword) async {
    return await ParseUser(email, password, email).login().then((response) async {
      if (response.success) {
        Singletons.user().password = newPassword;
        var object = _service.getObject();
        object.objectId = Singletons.user().id;
        object.set("password", newPassword);
        return await object.update().then((value) {
          return value.success ? value.result.toJson() : throw value.error;
        });
      } else {
        switch (response.error.code) {
          case -1:
            throw Exception(ERROR_NETWORK);
            break;
          default:
            throw Exception(response.error.message);
        }
      }
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        case 101:
          throw Exception(ERROR_LOGIN_PASSWORD);
          break;
        default:
          throw Exception(error.message);
      }
    });
  }

  @override
  Future<bool> changeName(String name) async {
    Singletons.user().name = name;
    return await update(Singletons.user()) == null ? false : true;
  }

  @override
  Future<String> changeUserPhoto(File image) async {
    image = image.renameSync(image.path);

    var file = ParseFile(image);
    var object = ParseObject("_User");
    object.objectId = Singletons.user().id;

    return await file.save().then((value) async {
      if (value.success) {
        var result = value.result;
        object.set("avatarURL", result.url);
        object.set("avatar", result);
        return await object.update().then((value) {
          if (value.success) {
            Singletons.user().avatarURL = result.url;
            return result.url;
          } else {
            throw value.error;
          }
        }).catchError((error) {
          throw Exception(ERROR_NETWORK);
        });
      } else {
        throw value.error;
      }
    }).catchError((error) {
      switch (error.code) {
        case -1:
          throw Exception(ERROR_NETWORK);
          break;
        default:
          throw error;
      }
    });
  }

  @override
  Future<BaseUser> currentUser() async {
    ParseUser currentUser = await ParseUser.currentUser();
    if (currentUser == null) {
      return null;
    } else {
      var userData = await PreferencesUtil.getUserData();
      var user = BaseUser.fromMap(userData);
      if (!user.isAnonymous() && (!user.emailVerified || user.notificationToken == null || user.phoneNumber == null)) {
        return read(BaseUser(id: currentUser.objectId)).then((value) {
          return value;
        }).catchError((error) async {
          return user;
        });
      } else {
        return user;
      }
    }
  }

  @override
  Future<void> signOut() async {
    PreferencesUtil.setUserData(null);
    ParseUser currentUser = await ParseUser.currentUser();
    PreferencesUtil.setNotificationToken(null);
    await currentUser.logout();
  }

  @override
  Future<bool> isEmailVerified() async {
    ParseUser currentUser = await ParseUser.currentUser();
    return currentUser.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    ParseUser currentUser = await ParseUser.currentUser();
    return await currentUser.verificationEmailRequest().then((response) {
      return response.success ? null : throw Exception(response.error.message);
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

}