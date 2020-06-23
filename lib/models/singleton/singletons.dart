import 'company_list_singleton.dart';
import 'order_list_singleton.dart';
import 'package:get_it/get_it.dart';
import '../../models/base_user.dart';
import '../../models/singleton/notification_list_singleton.dart';

class Singletons {

  static init() {
    final getIt = GetIt.instance;
    getIt.registerSingleton<BaseUser>(BaseUser());
    getIt.registerSingleton<NotificationListSingleton>(NotificationListSingleton());
    getIt.registerSingleton<OrderListSingleton>(OrderListSingleton());
    getIt.registerSingleton<CompanyListSingleton>(CompanyListSingleton());
  }

}