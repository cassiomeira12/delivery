import '../base_model.dart';

class States extends BaseModel<States> {
  String idCountry;
  String nameCountry;
  String codeCountry;
  String name;
  String code;
  String timeAPI;

  States() : super('State');

  States.fromMap(Map<dynamic, dynamic>  map) : super('State') {
    id = map["objectId"];
    idCountry = map["idCountry"];
    nameCountry = map["nameCountry"];
    codeCountry = map["codeCountry"];
    name = map["name"];
    code = map["code"];
    timeAPI = map["timeAPI"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["idCountry"] = idCountry;
    map["nameCountry"] = nameCountry;
    map["codeCountry"] = codeCountry;
    map["name"] = name;
    map["code"] = code;
    map["timeAPI"] = timeAPI;
    return map;
  }

//  @override
//  update(States item) {
//    id = item.id;
//    idCountry = item.idCountry;
//    nameCountry = item.nameCountry;
//    codeCountry = item.codeCountry;
//    name = item.name;
//    code = item.code;
//    timeAPI = item.timeAPI;
//  }

}