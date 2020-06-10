import 'package:delivery/models/address/small_town.dart';

import '../base_model.dart';
import 'city.dart';

class Address extends BaseModel<Address> {
  String userId;
  String zipCode;
  String neighborhood;
  String street;
  String number;
  String reference;
  City city;
  Map location;
  SmallTown smallTown;

  Address();

  Address.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    userId = map["userId"];
    zipCode = map["zipCode"];
    neighborhood = map["neighborhood"];
    street = map["street"];
    number = map["number"];
    reference = map["reference"];
    city = City.fromMap(map["city"]);
    location = map["location"] == null ? null : Map.from(map["location"]);
    smallTown = map["smallTown"] == null ? null : SmallTown.fromMap(map["smallTown"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["userId"] = userId;
    map["zipCode"] = zipCode;
    map["neighborhood"] = neighborhood;
    map["street"] = street;
    map["number"] = number;
    map["reference"] = reference;
    map["city"] = city == null ? null : city.toMap();
    map["location"] = location;
    map["smallTown"] = smallTown == null ? null : smallTown.toMap();
    return map;
  }

  @override
  update(Address item) {
    id = item.id;
    userId = item.userId;
    zipCode = item.zipCode;
    neighborhood = item.neighborhood;
    street = item.street;
    number = item.number;
    reference = item.reference;
    city = item.city;
    location = item.location;
    smallTown = item.smallTown;
  }

}