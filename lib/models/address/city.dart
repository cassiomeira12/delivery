import '../base_model.dart';

class City extends BaseModel<City> {
  String name;
  String idState;
  String nameState;
  String codeState;

  City() : super('City');

  City.fromMap(Map<dynamic, dynamic>  map) : super('City') {
    id = map["objectId"];
    name = map["name"];
    idState = map["idState"];
    nameState = map["nameState"];
    codeState = map["codeState"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["name"] = name;
    map["idState"] = idState;
    map["nameState"] = nameState;
    map["codeState"] = codeState;
    return map;
  }

//  @override
//  update(City item) {
//    id = item.id;
//    name = item.name;
//    idState = item.idState;
//    nameState = item.nameState;
//    codeState = item.codeState;
//  }

  @override
  String toString() {
    this.get("name");
    return "$name - $codeState";
  }

}