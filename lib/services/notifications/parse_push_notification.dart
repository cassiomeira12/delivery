import 'package:delivery/utils/log_util.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class ParsePushNotification {

  ParsePushNotification() {
    initInstallation();
  }

  Future<void> initInstallation() async {
    final ParseInstallation installation = await ParseInstallation.currentInstallation();
    Log.d(installation.toJson());
    final ParseResponse response = await installation.create();
  }

}