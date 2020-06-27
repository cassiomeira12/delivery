import '../../models/base_user.dart';
import '../../models/address/small_town.dart';
import '../base_model.dart';
import 'city.dart';

class Address extends BaseModel<Address> {
  BaseUser user;
  String zipCode;
  String neighborhood;
  String street;
  String number;
  String reference;
  City city;
  Map location;
  SmallTown smallTown;

  Address() : super('Address');

  Address.fromMap(Map<dynamic, dynamic>  map) : super('Address') {
    objectId = map["objectId"];
    id = objectId;
    user = map["user"] == null ? null : BaseUser.fromMap(map["user"]);
    zipCode = map["zipCode"];
    neighborhood = map["neighborhood"];
    street = map["street"];
    number = map["number"];
    reference = map["reference"];
    city = map["city"] == null ? null : City.fromMap(map["city"]);
    location = map["location"] == null ? null : Map.from(map["location"]);
    smallTown = map["smallTown"] == null ? null : SmallTown.fromMap(map["smallTown"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["user"] = user == null ? null : user.toPointer();
    map["zipCode"] = zipCode;
    map["neighborhood"] = neighborhood;
    map["street"] = street;
    map["number"] = number;
    map["reference"] = reference;
    map["city"] = city == null ? null : city.toPointer();
    map["location"] = location;
    map["smallTown"] = smallTown == null ? null : smallTown.toPointer();
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