import 'package:dio/dio.dart';

class TimeService {
  Dio dio;

  TimeService(String url, {timeout = 3000}) {
    dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: timeout,
    ));
  }

  Future<DateTime> now() async {
    try {
      Response response = await dio.get("");
      var date = DateTime.parse(response.data["datetime"]);
      return date.toLocal();
    } catch (error) {
      print(error);
      return null;
    }
  }

}