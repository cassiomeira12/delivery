
import 'package:delivery/utils/log_util.dart';
import 'package:latlong/latlong.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../base_model.dart';
import 'city.dart';

class SmallTown extends BaseModel<SmallTown> {
  String name;
  City city;
  //Map location;
  LatLng location;

  SmallTown() : super('SmallTown');

  SmallTown.fromMap(Map<dynamic, dynamic>  map) : super('SmallTown') {
    id = map["objectId"];
    name = map["name"];
    city = map["city"] == null ? null : City.fromMap(map["city"]);//City().fromJson(map["city"]);
//    if (map["location"] != null) {
//      var point = map["location"];
//      var lat = (point.latitude as num).toDouble();
//      var lon = (point.longitude as num).toDouble();
//      location = LatLng(lat, lon);
//    }
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["name"] = name;
    map["city"] = city == null ? null : city.toMap();
    //map["location"] = location == null ? null : ParseGeoPoint(latitude: location.latitude, longitude: location.longitude).toJson();
    return map;
  }

//  @override
//  update(SmallTown item) {
//    id = item.id;
//    name = item.name;
//    city = item.city;
//    location = item.location;
//  }

  @override
  String toString() {
    return name;
  }

}