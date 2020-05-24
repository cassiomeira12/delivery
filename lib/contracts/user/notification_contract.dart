import '../../contracts/base_result_contract.dart';
import '../../models/user_notification.dart';
import '../crud.dart';

abstract class NotificationContractView implements BaseResultContract<UserNotification> {

}

abstract class NotificationContractPresenter extends Crud<UserNotification> {
  NotificationContractView view;
  NotificationContractPresenter(this.view);

  dispose() {
    this.view = null;
  }
}

abstract class NotificationContractService extends Crud<UserNotification> {

}