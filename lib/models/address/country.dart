import '../base_model.dart';

class Country extends BaseModel<Country> {
  String name;
  String code;

  Country() : super('Country');

  Country.fromMap(Map<dynamic, dynamic>  map) : super('Country') {
    id = map["objectId"];
    name = map["name"];
    code = map["code"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["name"] = name;
    map["code"] = code;
    return map;
  }

//  @override
//  update(Country item) {
//    id = item.id;
//    name = item.name;
//    code = item.code;
//  }

}