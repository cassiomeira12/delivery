import '../models/base_model.dart';

class VersionApp extends BaseModel<VersionApp> {
  String name;
  int currentCode;
  int minimumCode;
  String storeUrl;

  int installedCode = 0;

  VersionApp() : super('');

  VersionApp.fromMap(Map<dynamic, dynamic> map) : super('VersionApp') {
    objectId = map["objectId"];
    id = objectId;
    name = map["name"];
    currentCode = (map["currentCode"] as num).toInt();
    minimumCode = (map["minimumCode"] as num).toInt();
    storeUrl = map["storeUrl"];
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map["objectId"] = id;
    map["name"] = name;
    map["currentCode"] = currentCode;
    map["minimumCode"] = minimumCode;
    map["storeUrl"] = storeUrl;
    return map;
  }

  void updateData(VersionApp versionApp) {
    objectId = versionApp.objectId;
    id = versionApp.id;
    name = versionApp.name;
    currentCode = versionApp.currentCode;
    minimumCode = versionApp.minimumCode;
    storeUrl = versionApp.storeUrl;
    installedCode = versionApp.installedCode;
  }

  bool isAcceptVersion() {
    return installedCode <= currentCode;
  }

}