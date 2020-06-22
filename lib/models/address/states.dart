import '../base_model.dart';
import 'country.dart';

class States extends BaseModel<States> {
  String name;
  String code;
  String timeAPI;
  Country country;

  States() : super('State');

  States.fromMap(Map<dynamic, dynamic>  map) : super('State') {
    objectId = map["objectId"];
    id = objectId;
    name = map["name"];
    code = map["code"];
    timeAPI = map["timeAPI"];
    country = map["country"] == null ? null : Country.fromMap(map["country"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["name"] = name;
    map["code"] = code;
    map["timeAPI"] = timeAPI;
    map["country"] = country == null ? null : country.toPointer();
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