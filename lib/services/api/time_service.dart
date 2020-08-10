import 'package:dio/dio.dart';
import 'package:kideliver/services/parse/parse_init.dart';
import 'package:kideliver/utils/log_util.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TimeService {
  Dio dio;

  TimeService(String url, {timeout = 3000}) {
//    dio = Dio(BaseOptions(
//      baseUrl: url,
//      connectTimeout: timeout,
//    ));
    dio = Dio(BaseOptions(
      baseUrl: "https://pg-app-umn8hkxj0yfqr3tue4vyhpzr5j1zst.scalabl.cloud/1/functions/time",//ParseInit.serverUrl,
      headers: {
        'X-Parse-Application-Id': 'vP5eyem24FCRjqbzvfTx7KKgRN7WMk7RGObRBQfk',//ParseInit.appId,
        'X-Parse-Master-Key': 'KVDWPuw5t3D8IhxwWTZFy6VRfMgNk7QeWBk8RQib',//ParseInit.masterKey,
        'Content-Type': 'application/json',
      },
      connectTimeout: timeout,
    ));
  }

  Future<DateTime> now() async {
    final ParseCloudFunction function = ParseCloudFunction('time');
    final ParseResponse result = await function.executeObjectFunction<ParseObject>();
    if (result.success) {
      var resultData = result.result.toJson();
      var json = resultData["result"];
      var date = DateTime.parse(json["datetime"]);
      return date.toLocal();
    } else {
      return null;
    }
//    try {
//      Response response = await dio.get("");
//      print(response.realUri.path);
//      print(response.headers.toString());
//      var date = DateTime.parse(response.data["datetime"]);
//      return date.toLocal();
//    } catch (error) {
//      print(error);
//      return null;
//    }
  }

}