import 'package:parse_server_sdk/parse_server_sdk.dart';

class RequiredCompanyService {

  Future<bool> send(dynamic data) async {
    final ParseCloudFunction function = ParseCloudFunction('required_company');
    final Map<String, Object> params = {
      "data": parseEncode(data)
    };
    final ParseResponse result = await function.execute(parameters: params);
    return result.success;
  }

}