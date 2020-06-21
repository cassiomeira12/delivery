import 'package:delivery/services/parse/parse_notification_service.dart';

import '../../contracts/user/notification_contract.dart';
import '../../models/user_notification.dart';
import '../../services/firebase/firebase_notification_service.dart';

class NotificationPresenter extends NotificationContractPresenter {
  NotificationContractView _view;

  //NotificationContractService service = FirebaseNotificationService("notifications");
  NotificationContractService service = ParseNotificationService();

  NotificationPresenter(this._view);

  @override
  dispose() {
    service = null;
    _view = null;
  }

  @override
  Future<UserNotification> create(UserNotification item) {
    return service.create(item);
  }

  @override
  Future<UserNotification> read(UserNotification item) {
    return service.read(item);
  }

  @override
  Future<UserNotification> update(UserNotification item) {
    return service.update(item);
  }

  @override
  Future<UserNotification> delete(UserNotification item) {
    return service.delete(item);
  }

  @override
  Future<List<UserNotification>> findBy(String field, value) {
    return service.findBy(field, value);
  }

  @override
  Future<List<UserNotification>> list() async {
    await service.list().then((value) {
      if (_view != null) _view.listSuccess(value);
    }).catchError((error) {
      if (_view != null) _view.onFailure(error.message);
    });
  }

}