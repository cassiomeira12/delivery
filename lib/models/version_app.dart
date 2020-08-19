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

  void updateData(VersionApp item) {
    id = item.id;
    objectId = item.objectId;
    createdAt = item.createdAt;
    updatedAt = item.updatedAt;

    name = item.name;
    currentCode = item.currentCode;
    minimumCode = item.minimumCode;
    storeUrl = item.storeUrl;
    installedCode = item.installedCode;
  }

  bool isAcceptVersion() {
    return installedCode <= currentCode;
  }

}