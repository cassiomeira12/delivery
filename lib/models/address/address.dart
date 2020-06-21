import '../../models/address/small_town.dart';
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
  String cityName;
  String stateCode;
  Map location;
  SmallTown smallTown;
  String smallTownName;

  Address() : super('Address');

  Address.fromMap(Map<dynamic, dynamic>  map) : super('Address') {
    id = map["objectId"];
    //userId = map["user"];
    zipCode = map["zipCode"];
    neighborhood = map["neighborhood"];
    street = map["street"];
    number = map["number"];
    reference = map["reference"];
    city = map["city"] == null ? null : City.fromMap(map["city"]);
    cityName = map["cityName"];
    stateCode = map["stateCode"];
    location = map["location"] == null ? null : Map.from(map["location"]);
    smallTown = map["smallTown"] == null ? null : SmallTown.fromMap(map["smallTown"]);
    smallTownName = map["smallTownName"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    //map["user"] = userId;
    map["zipCode"] = zipCode;
    map["neighborhood"] = neighborhood;
    map["street"] = street;
    map["number"] = number;
    map["reference"] = reference;
    map["city"] = city == null ? null : city.toMap();
    map["cityName"] = cityName;
    map["stateCode"] = stateCode;
    map["location"] = location;
    map["smallTown"] = smallTown == null ? null : smallTown.toMap();
    map["smallTownName"] = smallTownName;
    return map;
  }

//  @override
//  update(Address item) {
//    id = item.id;
//    userId = item.userId;
//    zipCode = item.zipCode;
//    neighborhood = item.neighborhood;
//    street = item.street;
//    number = item.number;
//    reference = item.reference;
//    city = item.city;
//    location = item.location;
//    smallTown = item.smallTown;
//  }

}