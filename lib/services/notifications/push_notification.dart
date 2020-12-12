import 'package:kideliver/utils/log_util.dart';

import '../../models/base_user.dart';
import '../../models/singleton/singletons.dart';
import '../../services/notifications/firebase_push_notification.dart';
import '../../services/notifications/parse_push_notification.dart';
import '../../utils/preferences_util.dart';

class PushNotification {
  FirebasePushNotifications pushNotifications;

  PushNotification() {
    pushNotifications = FirebasePushNotifications();
    pushNotifications.setUpFirebase();
  }

  Future<NotificationToken> updateNotificationToken() async {
    String currentToken = await PreferencesUtil.getNotificationToken();
    NotificationToken userToken = Singletons.user().notificationToken;
    if (userToken == null ||
        (userToken.token == null || userToken.token != currentToken)) {
      if (userToken == null) {
        userToken = NotificationToken(currentToken);
        userToken.topics = List();
      } else {
        userToken.token = currentToken;
      }
    }
    pushNotifications.subscribeDefaultTopics();
    ParsePushNotification();
    return userToken;
  }
}
