import '../base_model.dart';
import 'city.dart';

class SmallTown extends BaseModel<SmallTown> {
  String name;
  City city;
  Map location;

  SmallTown();

  SmallTown.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    name = map["name"];
    city = City.fromMap(map["city"]);
    location = Map.from(map["location"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["city"] = city.toMap();
    map["location"] = location;
    return map;
  }

  @override
  update(SmallTown item) {
    id = item.id;
    name = item.name;
    city = item.city;
    location = item.location;
  }

  @override
  String toString() {
    return name;
  }

}