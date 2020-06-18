import '../../contracts/base_result_contract.dart';
import '../../models/user_notification.dart';
import '../crud.dart';

abstract class NotificationContractView implements BaseResultContract<UserNotification> {

}

abstract class NotificationContractPresenter extends Crud<UserNotification> {
  dispose();
}

abstract class NotificationContractService extends Crud<UserNotification> {

}