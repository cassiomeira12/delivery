import 'dart:io';
import '../../contracts/user/user_contract.dart';
import '../../models/base_user.dart';
import '../../models/singleton/singleton_user.dart';
import '../../strings.dart';
import '../../utils/log_util.dart';
import '../../utils/preferences_util.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'base_parse_service.dart';

class ParseUserService implements UserContractService {
  ParseObject _object;
  BaseParseService _service;

  ParseUserService() {
    _service = BaseParseService("_User");
    _object = _service.object;
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
        SingletonUser.instance.password = newPassword;
        _object.objectId = SingletonUser.instance.id;
        _object.set("password", newPassword);
        return await _object.update().then((value) {
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
    SingletonUser.instance.name = name;
    return await update(SingletonUser.instance) == null ? false : true;
  }

  @override
  Future<String> changeUserPhoto(File image) async {
//    String baseName = Path.basename(image.path);
//    String uID = SingletonUser.instance.id + baseName.substring(baseName.length - 4);
//    StorageReference storageReference = FirebaseStorage.instance.ref().child("users/${uID}");
//    StorageUploadTask uploadTask = storageReference.putFile(image);
//    return await uploadTask.onComplete.then((value) async {
//      return await storageReference.getDownloadURL().then((fileURL) async {
//        SingletonUser.instance.avatarURL = fileURL;
//        return await update(SingletonUser.instance) == null ? null : fileURL;
//      }).catchError((error) {
//        print(error.message);
//        return null;
//      });
//    }).catchError((error) {
//      print(error.message);
//      return null;
//    });
  }

  @override
  Future<BaseUser> currentUser() async {
    ParseUser currentUser = await ParseUser.currentUser();
    if (currentUser == null) {
      return null;
    } else {
      var userData = await PreferencesUtil.getUserData();
      return userData == null ? null : BaseUser.fromMap(userData);
    }
  }

  @override
  Future<void> signOut() async {
    PreferencesUtil.setUserData(null);
    ParseUser currentUser = await ParseUser.currentUser();
    await currentUser.logout();
  }

  @override
  Future<bool> isEmailVerified() async {
    ParseUser currentUser = await ParseUser.currentUser();
    return currentUser.emailVerified;
//    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//    bool emailVerified = currentUser.isEmailVerified;
//    BaseUser user = await findUserByEmail(currentUser.email);
//    if (user != null) {
//      user.emailVerified = emailVerified;
//      _collection.document(user.id).updateData(user.toMap());
//    }
//    return emailVerified;
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