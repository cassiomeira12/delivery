import '../../models/order/cupon.dart';
import '../../models/base_user.dart';
import '../../models/company/company.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class CuponService {

  Future<Cupon> check(String code, {BaseUser user, Company company}) async {
    final ParseCloudFunction function = ParseCloudFunction('check_cupon');
    final Map<String, Object> params = {
      "code": code,
      "userRequired": user != null ? user.id : null,
      "companyRequired": company != null ? company.id : null,
    };
    final ParseResponse result = await function.execute(parameters: params);
    return result.success ? Cupon.fromMap(result.result) : throw result.error;
  }

}