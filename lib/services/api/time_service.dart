import 'package:delivery/utils/log_util.dart';
import 'package:dio/dio.dart';

class TimeService {
  Dio dio;

  TimeService(String url) {
    dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: 5000,
    ));
  }

  Future<DateTime> now() async {
    try {
      Response response = await dio.get("");
      var date = DateTime.parse(response.data["datetime"]);
      return date.toLocal();
    } catch (error) {
      return null;
    }
  }

}