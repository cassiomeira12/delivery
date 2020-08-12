import '../../services/notifications/push_notification.dart';
import '../../models/menu/menu.dart';
import '../../models/singleton/menu_map_singleton.dart';
import 'package:get_it/get_it.dart';
import '../version_app.dart';
import 'company_list_singleton.dart';
import 'order_list_singleton.dart';
import '../../models/company/company.dart';
import '../../models/order/order.dart';
import '../../models/user_notification.dart';
import '../../models/base_user.dart';
import '../../models/singleton/notification_list_singleton.dart';

class Singletons {

  static init() {
    GetIt.instance.registerSingleton<BaseUser>(BaseUser());
    GetIt.instance.registerSingleton<NotificationListSingleton>(NotificationListSingleton());
    GetIt.instance.registerSingleton<OrderListSingleton>(OrderListSingleton());
    GetIt.instance.registerSingleton<Order>(Order());
    GetIt.instance.registerSingleton<CompanyListSingleton>(CompanyListSingleton());
    GetIt.instance.registerSingleton<MenuMapSingleton>(MenuMapSingleton());
    GetIt.instance.registerSingleton<PushNotification>(PushNotification());
    GetIt.instance.registerSingleton<VersionApp>(VersionApp());
  }

  static BaseUser user() {
    return GetIt.instance<BaseUser>();
  }

  static Order order() {
    return GetIt.instance<Order>();
  }

  static List<UserNotification> notifications() {
    return GetIt.instance<NotificationListSingleton>().list;
  }

  static List<Order> orders() {
    return GetIt.instance<OrderListSingleton>().list;
  }

  static List<Company> companies() {
    return GetIt.instance<CompanyListSingleton>().list;
  }

  static Map<String, Menu> menus() {
    return GetIt.instance<MenuMapSingleton>().map;
  }

  static PushNotification pushNotification() {
    return GetIt.instance<PushNotification>();
  }

  static VersionApp versionApp() {
    return GetIt.instance<VersionApp>();
  }

}