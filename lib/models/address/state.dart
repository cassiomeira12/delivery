import '../base_model.dart';

class State extends BaseModel<State> {
  String idCountry;
  String nameCountry;
  String codeCountry;
  String name;
  String code;

  State();

  State.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    idCountry = map["idCountry"];
    nameCountry = map["nameCountry"];
    codeCountry = map["codeCountry"];
    name = map["name"];
    code = map["code"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["idCountry"] = idCountry;
    map["nameCountry"] = nameCountry;
    map["codeCountry"] = codeCountry;
    map["name"] = name;
    map["code"] = code;
    return map;
  }

  @override
  update(State item) {
    id = item.id;
    idCountry = item.idCountry;
    nameCountry = item.nameCountry;
    codeCountry = item.codeCountry;
    name = item.name;
    code = item.code;
  }

}