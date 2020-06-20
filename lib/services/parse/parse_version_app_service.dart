import '../../models/version_app.dart';
import '../../services/parse/base_parse_service.dart';

class ParseVersionAppService {
  BaseParseService service = BaseParseService("VersionApp");

  Future<VersionApp> checkCurrentVersion(String packageName) async {
    return await service.findBy("packageName", packageName).then((value) {
      print(value);
      return VersionApp.fromMap(value[0]);
    }).catchError((error) {
      print(error);
      return null;
    });
  }

}