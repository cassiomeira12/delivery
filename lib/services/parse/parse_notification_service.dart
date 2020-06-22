import '../../contracts/user/notification_contract.dart';
import '../../models/user_notification.dart';
import '../../services/parse/base_parse_service.dart';
import '../../strings.dart';

class ParseNotificationService extends NotificationContractService {

  BaseParseService service = BaseParseService("UserNotification");

  @override
  Future<UserNotification> create(UserNotification item) async {
    return service.create(item).then((response) {
      item.id = response["objectId"];
      item.objectId = response["objectId"];
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
  Future<UserNotification> read(UserNotification item) {
    return service.read(item).then((response) {
      return response == null ? null : UserNotification.fromMap(response);
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
  Future<UserNotification> update(UserNotification item) {
    return service.update(item).then((response) {
      return response == null ? null : UserNotification.fromMap(response);
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
  Future<UserNotification> delete(UserNotification item) {
    return service.delete(item).then((response) {
      return response == null ? null : UserNotification.fromMap(response);
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
  Future<List<UserNotification>> findBy(String field, value) async {
    return service.findBy(field, value).then((response) {
      return response.isEmpty ? List<UserNotification>() : response.map<UserNotification>((item) => UserNotification.fromMap(item)).toList();
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
  Future<List<UserNotification>> list() {
    return service.list().then((response) {
      return response.isEmpty ? List<UserNotification>() : response.map<UserNotification>((item) => UserNotification.fromMap(item)).toList();
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