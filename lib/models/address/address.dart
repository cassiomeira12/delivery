import '../base_model.dart';
import 'city.dart';

class Address extends BaseModel<Address> {
  String zipCode;
  String neighborhood;
  String street;
  String number;
  String reference;
  City city;
  Map location;

  Address();

  Address.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    zipCode = map["zipCode"];
    neighborhood = map["neighborhood"];
    street = map["street"];
    number = map["number"];
    reference = map["reference"];
    city = City.fromMap(map["city"]);
    location = Map.from(map["location"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["zipCode"] = zipCode;
    map["neighborhood"] = neighborhood;
    map["street"] = street;
    map["number"] = number;
    map["reference"] = reference;
    map["city"] = city.toMap();
    map["location"] = location;
    return map;
  }

  @override
  update(Address item) {
    id = item.id;
    zipCode = item.zipCode;
    neighborhood = item.neighborhood;
    street = item.street;
    number = item.number;
    reference = item.reference;
    city = item.city;
    location = item.location;
  }

}