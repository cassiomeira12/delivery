import 'package:parse_server_sdk/parse_server_sdk.dart';

class ParseInit {
  static String appId = "rjO6rerjoJZqZflcmwbYeL3NPWNKCHMN8A7gORUR";
  static String serverUrl = "https://pg-app-2r1bmfb3qhj3zsxrstuh78sq0i4x0b.scalabl.cloud/1/";
  static String masterKey = "kEDFmXLMsJFYi7FygmD1GVRNPRNORBHINWagKAGC";

  static Parse parse;

  static Future<bool> init() async {
    print("init start");
    parse = await Parse().initialize(
      appId,
      serverUrl,
      masterKey: masterKey,
      autoSendSessionId: true,
      debug: true,
    );
    print("init finish");
    return (await parse.healthCheck()).success;
  }

}