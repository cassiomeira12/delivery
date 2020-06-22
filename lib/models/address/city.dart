import '../../models/address/states.dart';
import '../base_model.dart';

class City extends BaseModel<City> {
  String name;
  States state;

  City() : super('City');

  City.fromMap(Map<dynamic, dynamic>  map) : super('City') {
    objectId = map["objectId"];
    id = objectId;
    name = map["name"];
    state = map["state"] == null ? null : States.fromMap(map["state"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["name"] = name;
    map["state"] = state == null ? null : state.toMap();
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
    return name;
  }

}