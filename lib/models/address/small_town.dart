import '../base_model.dart';
import 'city.dart';

class SmallTown extends BaseModel<SmallTown> {
  String name;
  String alias;
  City city;
  Map location;

  SmallTown();

  SmallTown.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    name = map["name"];
    alias = map["alias"];
    city = City.fromMap(map["city"]);
    location = Map.from(map["location"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["alias"] = alias;
    map["city"] = city.toMap();
    map["location"] = location;
    return map;
  }

  @override
  update(SmallTown item) {
    id = item.id;
    name = item.name;
    alias = item.alias;
    city = item.city;
    location = item.location;
  }

  @override
  String toString() {
    return alias == null ? name : "$name - $alias";
  }

}