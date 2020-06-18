import 'package:delivery/models/base_model.dart';

class VersionApp extends BaseModel<VersionApp> {
  String name;
  int currentCode;
  int minimumCode;
  String storeUrl;

  VersionApp.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    name = map["name"];
    currentCode = (map["currentCode"] as num).toInt();
    minimumCode = (map["minimumCode"] as num).toInt();
    storeUrl = map["storeUrl"];
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["currentCode"] = currentCode;
    map["minimumCode"] = minimumCode;
    map["storeUrl"] = storeUrl;
    return map;
  }

  @override
  update(VersionApp item) {}

}