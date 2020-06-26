import 'package:delivery/utils/log_util.dart';
import 'package:delivery/utils/preferences_util.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class ParsePushNotification {

  ParsePushNotification() {
    initInstallation();
  }

  Future<void> initInstallation() async {
    ParseInstallation installation = await ParseInstallation.currentInstallation();
    String notificationToken = await PreferencesUtil.getNotificationToken();
    installation.deviceToken = notificationToken;
    await installation.create();
  }

}